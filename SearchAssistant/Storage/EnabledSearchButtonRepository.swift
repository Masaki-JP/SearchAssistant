import Foundation
import SearchCore

struct EnabledSearchButtonRepository: EnabledSearchButtonRepositoryInterface {
    private static let key = UserDefaultsKey.enabledSearchButtons
    
    enum EnabledSearchButtonRepositoryError: Error {
        case dataNotSet
        case decodingError
        case encodingError
    }
    
    func save(_ value: [SearchPlatform]) throws(EnabledSearchButtonRepositoryError) {
        do {
            let encodedData = try JSONEncoder().encode(value)
            UserDefaults.standard.set(encodedData, forKey: Self.key.rawValue)
        } catch {
            reportError(error)
            throw EnabledSearchButtonRepositoryError.encodingError
        }
    }
    
    func load() throws(EnabledSearchButtonRepositoryError) -> [SearchPlatform] {
        guard let itemsData = UserDefaults.standard.data(forKey: Self.key.rawValue)
        else { throw EnabledSearchButtonRepositoryError.dataNotSet }
        
        do {
            let items = try JSONDecoder().decode([SearchPlatform].self, from: itemsData)
            return items
        } catch {
            reportError(error)
            throw EnabledSearchButtonRepositoryError.decodingError
        }
    }
}
