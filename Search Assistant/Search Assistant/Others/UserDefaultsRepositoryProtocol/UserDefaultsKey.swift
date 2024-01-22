import Foundation

enum UserDefaultsKey {
    case keyboardToolbarValidButtons
    case inMemory

    var string: String {
        return switch self {
        case .keyboardToolbarValidButtons:
            "keyboardToolbarValidButtons"
        case .inMemory:
            "sample3"
        }
    }
}
