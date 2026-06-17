import Foundation

enum UserDefaultsKey: String {
    case searchHistories = "historys" // ※1
    case validKeyboardToolbarButtons = "keyboardToolbarButtons" // ※2
}

// ※1: スペルが間違っているが、現在リリースされているバージョンでは historys となっているため、修正は行わない。
// ※2: 現在リリースされているバージョンでは keyboardToolbarButtons となっているため、修正は行わない。
