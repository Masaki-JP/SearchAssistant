import SwiftUI

/// rawValue は @AppStorage によって UserDefaults への保存・復元に使用される。
///
enum ColorSchemeSetting: String, CaseIterable, Identifiable {
    case light
    case dark
    case system

    static let defaultValue = ColorSchemeSetting.system

    var id: Self { self }

    var label: String {
        switch self {
        case .light: "ライト"
        case .dark: "ダーク"
        case .system: "システム"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: .light
        case .dark: .dark
        case .system: .none
        }
    }
}
