import Foundation

enum UserDefaultsKey {
    case searchHistories
    case validKeyboardToolbarButtons
    
    var string: String {
        return switch self {
        case .searchHistories:
            "histories"
        case .validKeyboardToolbarButtons:
            "keyboardToolbarButtons"
        }
    }
}
