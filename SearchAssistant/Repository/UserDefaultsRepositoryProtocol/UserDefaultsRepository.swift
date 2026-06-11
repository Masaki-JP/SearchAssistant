import Foundation

final class UserDefaultsRepository<Value: Codable>: UserDefaultsRepositoryProtocol {
    private let userDefaultsKey: UserDefaultsKey
    
    init(key: UserDefaultsKey) {
        self.userDefaultsKey = key
    }
    
    enum UserDefaultsRepositoryError: Error {
        case dataNotFound
        case decodingError
        case encodingError
    }
    
    func save(_ value: Value) throws {
        do {
            let encodedData = try JSONEncoder().encode(value)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey.string)
        } catch {
            reportError(error)
            throw UserDefaultsRepositoryError.encodingError
        }
    }
    
    func fetch() throws -> Value {
        guard let itemsData = UserDefaults.standard.data(forKey: userDefaultsKey.string)
        else { throw UserDefaultsRepositoryError.dataNotFound }
        do {
            let items = try JSONDecoder().decode(Value.self, from: itemsData)
            return items
        } catch {
            reportError(error)
            throw UserDefaultsRepositoryError.decodingError
        }
    }
}
