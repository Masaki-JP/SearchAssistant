import Foundation
import SearchCore

final class EnabledKeyboardToolbarButtonRepository {
    private let key = UserDefaultsKey.enabledKeyboardToolbarButtons
    
    enum EnabledKeyboardToolbarButtonRepositoryError: Error {
        case dataNotSet
        case decodingError
        case encodingError
    }
    
    func save(_ value: [SearchPlatform]) throws(EnabledKeyboardToolbarButtonRepositoryError) {
        do {
            let encodedData = try JSONEncoder().encode(value)
            UserDefaults.standard.set(encodedData, forKey: key.rawValue)
        } catch {
            reportError(error)
            throw EnabledKeyboardToolbarButtonRepositoryError.encodingError
        }
    }
    
    func load() throws(EnabledKeyboardToolbarButtonRepositoryError) -> [SearchPlatform] {
        guard let itemsData = UserDefaults.standard.data(forKey: key.rawValue)
        else { throw EnabledKeyboardToolbarButtonRepositoryError.dataNotSet }
        
        do {
            let items = try JSONDecoder().decode([SearchPlatform].self, from: itemsData)
            return items
        } catch {
            reportError(error)
            throw EnabledKeyboardToolbarButtonRepositoryError.decodingError
        }
    }
}
