import Foundation

enum UserDefaultsKey {
    case searchHistories
    case validKeyboardToolbarButtons
    
    var string: String {
        return switch self {
        case .searchHistories:
            "historys" // ※1
        case .validKeyboardToolbarButtons:
            "keyboardToolbarButtons"
        }
    }
}

// ※1: スペルが間違っているが、現在リリースされているバージョンでは historys となっているため、修正は行わない。
