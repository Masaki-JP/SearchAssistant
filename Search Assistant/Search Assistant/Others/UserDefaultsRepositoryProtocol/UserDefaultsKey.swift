import Foundation

enum UserDefaultsKey {
    case inMemory

    var string: String {
        return switch self {
        case .inMemory:
            "sample3"
        }
    }
}
