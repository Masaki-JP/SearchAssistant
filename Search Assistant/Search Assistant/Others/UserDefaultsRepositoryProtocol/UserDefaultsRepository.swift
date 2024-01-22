import Foundation

final class UserDefaultsRepository<Object: Codable>: UserDefaultsRepositoryProtocol {
    private let userDefaultsKey: UserDefaultsKey

    init(key: UserDefaultsKey) {
        self.userDefaultsKey = key
    }

    enum UserDefaultsRepositoryError: Error {
        case dataNotFound
        case decodingError
        case encodingError
    }

    func save(_ object: Object) throws {
        do {
            let encodedData = try JSONEncoder().encode(object)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey.string)
        } catch {
            reportError(error)
            throw UserDefaultsRepositoryError.encodingError
        }
    }

    func fetch() throws -> Object {
        guard let itemsData = UserDefaults.standard.data(forKey: userDefaultsKey.string)
        else { throw UserDefaultsRepositoryError.dataNotFound }
        do {
            let items = try JSONDecoder().decode(Object.self, from: itemsData)
            return items
        } catch {
            reportError(error)
            throw UserDefaultsRepositoryError.decodingError
        }
    }
}
