import Foundation

enum UserDefaultsKey {
    case searchHistories
    case validKeyboardToolbarButtons
    // モック用のUserDefaultsKeyとして使うことを想定しています。
    case inMemory
    
    var string: String {
        return switch self {
        case .searchHistories:
            "histories"
        case .validKeyboardToolbarButtons:
            "keyboardToolbarButtons"
        case .inMemory:
            "inMemory"
        }
    }
}
