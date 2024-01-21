import Foundation

final class UserDefaultsRepository<Item: Codable>: UserDefaultsRepositoryProtocol {
    private let userDefaultsKey: UserDefaultsKey

    init(key: UserDefaultsKey) {
        self.userDefaultsKey = key
    }

    enum UserDefaultsRepositoryError: Error {
        case dataNotFound
        case decodingError
        case encodingError
    }

    func save(_ items: [Item]) throws {
        do {
            let encodedData = try JSONEncoder().encode(items)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey.string)
        } catch {
            reportError(error)
            throw UserDefaultsRepositoryError.encodingError
        }
    }

    func fetch() throws -> [Item] {
        guard let itemsData = UserDefaults.standard.data(forKey: userDefaultsKey.string)
        else { throw UserDefaultsRepositoryError.dataNotFound }
        do {
            let items = try JSONDecoder().decode([Item].self, from: itemsData)
            return items
        } catch {
            reportError(error)
            throw UserDefaultsRepositoryError.decodingError
        }
    }
}
