import Foundation

final class ValidKeyboardToolbarButtonRepository {
    private let key = UserDefaultsKey.validKeyboardToolbarButtons
    
    enum ValidKeyboardToolbarButtonRepositoryError: Error {
        case dataNotFound
        case decodingError
        case encodingError
    }
    
    func save(_ value: [SearchPlatform]) throws {
        do {
            let encodedData = try JSONEncoder().encode(value)
            UserDefaults.standard.set(encodedData, forKey: key.string)
        } catch {
            reportError(error)
            throw ValidKeyboardToolbarButtonRepositoryError.encodingError
        }
    }
    
    func load() throws -> [SearchPlatform] {
        guard let itemsData = UserDefaults.standard.data(forKey: key.string)
        else { throw ValidKeyboardToolbarButtonRepositoryError.dataNotFound }
        do {
            let items = try JSONDecoder().decode([SearchPlatform].self, from: itemsData)
            return items
        } catch {
            reportError(error)
            throw ValidKeyboardToolbarButtonRepositoryError.decodingError
        }
    }
}
