import AVFoundation
import SwiftUI

/// Reads a chapter aloud with the system voice, one verse per utterance so the reader can follow along.
@MainActor
final class Speaker: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published private(set) var verse: Int?
    @Published private(set) var playing = false
    private let synth = AVSpeechSynthesizer()
    private var numbers: [ObjectIdentifier: Int] = [:]

    override init() {
        super.init()
        synth.delegate = self
    }

    func play(_ verses: [String], from start: Int = 0) {
        stop()
        #if os(iOS)
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif
        for (i, v) in verses.enumerated() where i >= start {
            let u = AVSpeechUtterance(string: v)
            u.voice = AVSpeechSynthesisVoice(language: "en-US")
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
        numbers.removeAll(); verse = nil; playing = false
    }

    nonisolated func speechSynthesizer(_ s: AVSpeechSynthesizer, didStart u: AVSpeechUtterance) {
        let id = ObjectIdentifier(u)
        Task { @MainActor in self.verse = self.numbers[id] }
    }

    nonisolated func speechSynthesizer(_ s: AVSpeechSynthesizer, didFinish u: AVSpeechUtterance) {
        Task { @MainActor in if !self.synth.isSpeaking { self.verse = nil; self.playing = false } }
    }
}
