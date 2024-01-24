import Foundation

enum UserDefaultsKey {
    case searchHistorys
    case validKeyboardToolbarButtons
    case inMemory

    var string: String {
        return switch self {
        case .searchHistorys:
            "historys"
        case .validKeyboardToolbarButtons:
            "keyboardToolbarButtons"
        case .inMemory:
            "inMemory"
        }
    }
}
