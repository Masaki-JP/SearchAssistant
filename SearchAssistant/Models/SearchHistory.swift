import Foundation
import SwiftData

typealias SearchHistory = SearchAssistantSchemaV1.SearchHistory

enum SearchAssistantSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version {
        .init(1, 0, 0)
    }
    
    static var models: [any PersistentModel.Type] {
        [SearchHistory.self]
    }
    
    @Model
    final class SearchHistory: Equatable {
        static let maximumCount = 3_000
        
        private(set) var userInput: String
        private(set) var platformRawValue: String
        private(set) var date: Date
        
        var platform: SearchPlatform? {
            .init(rawValue: platformRawValue)
        }
        
        init(userInput: String, platform: SearchPlatform, date: Date = .now) {
            self.userInput = userInput
            self.platformRawValue = platform.rawValue
            self.date = date
        }
        
        init(userInput: String, platformRawValue: String, date: Date = .now) {
            self.userInput = userInput
            self.platformRawValue = platformRawValue
            self.date = date
        }
        
        static func trimIfNeeded(using modelContext: ModelContext) throws {
            let fetchDescriptor = FetchDescriptor<SearchHistory>(
                sortBy: [SortDescriptor(\SearchHistory.date, order: .reverse)]
            )
            let allHistories = try modelContext.fetch(fetchDescriptor)
            let historiesToDelete = allHistories.dropFirst(maximumCount)
            
            historiesToDelete.forEach(modelContext.delete)
        }
        
        static var sample: SearchHistory {
            samples.first!
        }
        
        static var samples: [SearchHistory] {
            [
                .init(userInput: "iPhone 15 Pro", platform: .google),
                .init(userInput: "iPad Pro", platform: .x),
                .init(userInput: "Studio Display", platform: .instagram),
                .init(userInput: "AirPods", platform: .mercari),
                .init(userInput: "iMac", platform: .amazon),
                .init(userInput: "Apple Pencil", platform: .youtube),
                .init(userInput: "MacBook Air", platform: .facebook),
                .init(userInput: "Xcode", platform: .google),
                .init(userInput: "Apple Watch", platform: .x),
                .init(userInput: "AirPods", platform: .rakuma),
                .init(userInput: "iPod touch", platform: .instagram),
                .init(userInput: "Apple Vision Pro", platform: .amazon),
                .init(userInput: "Safari", platform: .youtube),
                .init(userInput: "Tim Cook", platform: .facebook),
                .init(userInput: "iPhone SE", platform: .google),
                .init(userInput: "Apple Store", platform: .amazon),
                .init(userInput: "Steve Jobs", platform: .yahooFleaMarket),
                .init(userInput: "Apple Watch Ultra", platform: .google),
                .init(userInput: "iCloud", platform: .amazon),
                .init(userInput: "Apple Music", platform: .google),
            ]
        }
    }
}
