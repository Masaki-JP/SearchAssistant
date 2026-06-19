import Foundation
import SearchCore

final class ValidKeyboardToolbarButtonRepository {
    private let key = UserDefaultsKey.validKeyboardToolbarButtons
    
    enum ValidKeyboardToolbarButtonRepositoryError: Error {
        case dataNotSet
        case decodingError
        case encodingError
    }
    
    func save(_ value: [SearchPlatform]) throws(ValidKeyboardToolbarButtonRepositoryError) {
        do {
            let encodedData = try JSONEncoder().encode(value)
            UserDefaults.standard.set(encodedData, forKey: key.rawValue)
        } catch {
            reportError(error)
            throw ValidKeyboardToolbarButtonRepositoryError.encodingError
        }
    }
    
    func load() throws(ValidKeyboardToolbarButtonRepositoryError) -> [SearchPlatform] {
        guard let itemsData = UserDefaults.standard.data(forKey: key.rawValue)
        else { throw ValidKeyboardToolbarButtonRepositoryError.dataNotSet }
        
        do {
            let items = try JSONDecoder().decode([SearchPlatform].self, from: itemsData)
            return items
        } catch {
            reportError(error)
            throw ValidKeyboardToolbarButtonRepositoryError.decodingError
        }
    }
}
