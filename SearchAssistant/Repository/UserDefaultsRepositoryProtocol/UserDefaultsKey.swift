import Foundation

enum UserDefaultsKey {
    case searchHistories
    case validKeyboardToolbarButtons
    case inMemory
    
    var string: String {
        return switch self {
        case .searchHistories:
            "historys"
        case .validKeyboardToolbarButtons:
            "keyboardToolbarButtons"
        case .inMemory:
            "inMemory"
        }
    }
}
