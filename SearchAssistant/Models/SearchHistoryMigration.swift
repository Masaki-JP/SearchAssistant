import Foundation
import SwiftData

enum SearchHistoryMigration {
    struct LegacySearchHistory: Decodable {
        let userInput: String
        let platformRawValue: String
        let date: Date
        
        enum CodingKeys: String, CodingKey {
            case userInput
            case platformRawValue = "platform"
            case date
        }
    }
    
    static func migrateIfNeeded(using modelContext: ModelContext) throws {
        guard UserDefaults.standard.bool(forKey: UserDefaultsKey.AppStorageKey.didMigrateSearchHistoriesToSwiftData.rawValue) == false else { return }
        
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.searchHistories.rawValue) else {
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.AppStorageKey.didMigrateSearchHistoriesToSwiftData.rawValue)
            return
        }
        
        do {
            let fetchDescriptor = FetchDescriptor<SearchHistory>()
            let existingHistoryCount = try modelContext.fetchCount(fetchDescriptor)
            
            if existingHistoryCount == .zero {
                let legacyHistories = try JSONDecoder().decode([LegacySearchHistory].self, from: data)
                
                legacyHistories.forEach { legacyHistory in
                    modelContext.insert(
                        SearchHistory(
                            userInput: legacyHistory.userInput,
                            platformRawValue: legacyHistory.platformRawValue,
                            date: legacyHistory.date
                        )
                    )
                }
                try SearchHistory.trimIfNeeded(using: modelContext)
                try modelContext.save()
            }
            
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.AppStorageKey.didMigrateSearchHistoriesToSwiftData.rawValue)
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}
