import SwiftUI

/// Mirrors brand/tokens.css. One accent, warm neutrals, 8 point grid.
enum Theme {
    static let accent = Color(light: 0x1745a8, dark: 0x6ea8ff)
    /// Filled buttons: white text stays readable in dark mode (5.4:1 on #2f66d0).
    static let button = Color(light: 0x1745a8, dark: 0x2f66d0)
    static let surface = Color(light: 0xf1ede6, dark: 0x211f1c)
    static let secondary = Color(light: 0x6b655c, dark: 0x9a948a)
    static let control: CGFloat = 48
    /// Bible Sans (Inter, OFL, quotes drawn as smooth stones), scaling with Dynamic Type.
    static func sans(_ size: CGFloat, _ weight: Font.Weight = .regular, relativeTo style: Font.TextStyle = .body) -> Font {
        .custom("Bible Sans", size: size, relativeTo: style).weight(weight)
    }
    static let page: CGFloat = 20
    static let measure: CGFloat = 680
}

extension Color {
    init(hex: UInt32) {
        self.init(red: Double(hex >> 16 & 0xff) / 255, green: Double(hex >> 8 & 0xff) / 255, blue: Double(hex & 0xff) / 255)
    }
    init(light: UInt32, dark: UInt32) {
        #if os(iOS)
        self.init(UIColor { $0.userInterfaceStyle == .dark ? UIColor(Color(hex: dark)) : UIColor(Color(hex: light)) })
        #else
        self.init(NSColor(name: nil) { $0.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(Color(hex: dark)) : NSColor(Color(hex: light)) })
        #endif
    }
}
