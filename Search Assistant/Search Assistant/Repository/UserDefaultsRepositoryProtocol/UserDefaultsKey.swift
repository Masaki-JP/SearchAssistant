import Foundation

enum UserDefaultsKey {
    case searchHistorys
    case keyboardToolbarValidButtons
    case inMemory

    var string: String {
        return switch self {
        case .searchHistorys:
            "historys"
        case .keyboardToolbarValidButtons:
            "keyboardToolbarValidButtons"
        case .inMemory:
            "inMemory"
        }
    }
}
