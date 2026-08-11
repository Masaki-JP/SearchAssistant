import Foundation

/// rawValue は UserDefaults のキー文字列として使用される。
///
enum UserDefaultsKey: String {
    case enabledSearchButtons = "keyboardToolbarButtons" // ※1
    case bookmarks
}

// ※1: 現在リリースされているバージョンで使用中のキーであるため、修正は行わない。
