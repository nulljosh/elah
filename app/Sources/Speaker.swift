import AVFoundation
import SwiftUI

/// Reads a chapter aloud with the system voice, one verse per utterance so the reader can follow along.
@MainActor
final class Speaker: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published private(set) var verse: Int?
    @Published private(set) var playing = false
    /// True from the first play until stop, so the bar stays up while paused.
    @Published private(set) var active = false
    @AppStorage("speechRate") var rate = 1.0
    private var verses: [String] = []
    private let synth = AVSpeechSynthesizer()
    private var numbers: [ObjectIdentifier: Int] = [:]

    override init() {
        super.init()
        synth.delegate = self
    }

    func play(_ verses: [String], from start: Int = 0) {
        stop()
        self.verses = verses
        active = true
        #if os(iOS)
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif
        for (i, v) in verses.enumerated() where i >= start {
            let u = AVSpeechUtterance(string: v)
            u.voice = AVSpeechSynthesisVoice(language: "en-US")
            u.rate = Float(Double(AVSpeechUtteranceDefaultSpeechRate) * rate)
            u.postUtteranceDelay = 0.15
            numbers[ObjectIdentifier(u)] = i + 1
            synth.speak(u)
        }
        playing = true
    }

    func toggle(_ verses: [String]) {
        if synth.isPaused { synth.continueSpeaking(); playing = true }
        else if synth.isSpeaking { synth.pauseSpeaking(at: .word); playing = false }
        else { play(verses) }
    }

    func stop() {
        synth.stopSpeaking(at: .immediate)
        numbers.removeAll(); verse = nil; playing = false; active = false
    }

    /// Jump a verse back or forward and keep reading from there.
    func skip(_ by: Int) {
        let target = max(0, min(verses.count - 1, (verse ?? 1) - 1 + by))
        play(verses, from: target)
    }

    /// New speed applies from the current verse.
    func setRate(_ r: Double) {
        rate = r
        if active { play(verses, from: max(0, (verse ?? 1) - 1)) }
    }

    /// QA only: shows the bar paused on a verse without making a sound.
    func preview(_ verses: [String], at n: Int) { self.verses = verses; verse = n; active = true; playing = false }

    nonisolated func speechSynthesizer(_ s: AVSpeechSynthesizer, didStart u: AVSpeechUtterance) {
        let id = ObjectIdentifier(u)
        Task { @MainActor in self.verse = self.numbers[id] }
    }

    nonisolated func speechSynthesizer(_ s: AVSpeechSynthesizer, didFinish u: AVSpeechUtterance) {
        Task { @MainActor in if !self.synth.isSpeaking { self.verse = nil; self.playing = false } }
    }
}
