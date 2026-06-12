import Foundation

enum UserDefaultsKey {
    case searchHistories
    case validKeyboardToolbarButtons
    case inMemory // MARK: モック用のUserDefaultsKeyとしての使用を想定
    
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
