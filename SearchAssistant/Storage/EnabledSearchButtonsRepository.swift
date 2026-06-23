import Foundation
import SearchCore

struct EnabledSearchButtonsRepository {
    private static let key = UserDefaultsKey.enabledSearchButtons
    
    enum EnabledSearchButtonsRepositoryError: Error {
        case dataNotSet
        case decodingError
        case encodingError
    }
    
    func save(_ value: [SearchPlatform]) throws(EnabledSearchButtonsRepositoryError) {
        do {
            let encodedData = try JSONEncoder().encode(value)
            UserDefaults.standard.set(encodedData, forKey: Self.key.rawValue)
        } catch {
            reportError(error)
            throw EnabledSearchButtonsRepositoryError.encodingError
        }
    }
    
    func load() throws(EnabledSearchButtonsRepositoryError) -> [SearchPlatform] {
        guard let itemsData = UserDefaults.standard.data(forKey: Self.key.rawValue)
        else { throw EnabledSearchButtonsRepositoryError.dataNotSet }
        
        do {
            let items = try JSONDecoder().decode([SearchPlatform].self, from: itemsData)
            return items
        } catch {
            reportError(error)
            throw EnabledSearchButtonsRepositoryError.decodingError
        }
    }
}
