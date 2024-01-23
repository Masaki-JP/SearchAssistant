import Foundation

enum UserDefaultsKey {
    case historys
    case keyboardToolbarValidButtons
    case inMemory

    var string: String {
        return switch self {
        case .historys:
            "historys"
        case .keyboardToolbarValidButtons:
            "keyboardToolbarValidButtons"
        case .inMemory:
            "inMemory"
        }
    }
}
