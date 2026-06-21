import Foundation

/// rawValue は UserDefaults のキー文字列として使用される。
///
enum UserDefaultsKey: String {
    case searchHistories = "historys" // ※1
    case enabledSearchButtons = "keyboardToolbarButtons" // ※2
}

// ※1: スペルが間違っているが、現在リリースされているバージョンでは historys となっているため、修正は行わない。
// ※2: 現在リリースされているバージョンで使用中のキーであるため、修正は行わない。
