import SwiftUI

/// Text size, typeface and line spacing. Everything is stored on the device and applies at once.
struct ReadingSettings: View {
    @AppStorage("textSize") private var textSize = 19.0
    @AppStorage("serif") private var serif = false
    @AppStorage("spacing") private var spacing = 0.35

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Reading").font(.headline)
            Text("And David put his hand in his bag, and took thence a stone.")
                .font(.system(size: textSize, design: serif ? .serif : .default))
                .lineSpacing(textSize * spacing)
                .frame(maxWidth: .infinity, minHeight: 72, alignment: .leading)
                .lineLimit(3)
            HStack(spacing: 12) {
                Image(systemName: "textformat.size.smaller").accessibilityHidden(true)
                Slider(value: $textSize, in: 13...34, step: 1).accessibilityLabel("Text size")
                Image(systemName: "textformat.size.larger").accessibilityHidden(true)
            }
            Picker("Typeface", selection: $serif) {
                Text("Sans").tag(false)
                Text("Serif").tag(true)
            }
            .pickerStyle(.segmented)
            Picker("Line spacing", selection: $spacing) {
                Text("Tight").tag(0.15)
                Text("Normal").tag(0.35)
                Text("Loose").tag(0.6)
            }
            .pickerStyle(.segmented)
        }
        .padding(24)
        .frame(minWidth: 320)
        .tint(Theme.accent)
    }
}
