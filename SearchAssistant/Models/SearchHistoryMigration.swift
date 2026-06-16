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
        guard UserDefaults.standard.bool(forKey: AppStorageKey.didMigrateSearchHistoriesToSwiftData) == false else { return }
        
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.searchHistories.string) else {
            UserDefaults.standard.set(true, forKey: AppStorageKey.didMigrateSearchHistoriesToSwiftData)
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
                try modelContext.save()
            }
            
            UserDefaults.standard.set(true, forKey: AppStorageKey.didMigrateSearchHistoriesToSwiftData)
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}
