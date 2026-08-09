import Foundation
import SwiftData
import SearchCore

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
        static let defaultMaximumCount = 3_000
        static let maximumCountOptions = [500, 1_000, 1_500, 2_000, 2_500, 3_000]
        
        static var maximumCount: Int {
            let maximumCount = UserDefaults.standard.integer(forKey: UserDefaultsKey.AppStorageKey.historyMaximumCount.rawValue)
            return maximumCountOptions.contains(maximumCount) ? maximumCount : defaultMaximumCount
        }
        
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
            let calendar = Calendar.autoupdatingCurrent
            func date(daysAgo: Int, hour: Int) -> Date {
                let todayAtHour = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: .now)!
                return calendar.date(byAdding: .day, value: -daysAgo, to: todayAtHour)!
            }
            
            return [
                .init(userInput: "iPhone 15 Pro", platform: .google, date: date(daysAgo: 0, hour: 9)),
                .init(userInput: "iPad Pro", platform: .x, date: date(daysAgo: 0, hour: 15)),
                .init(userInput: "Studio Display", platform: .instagram, date: date(daysAgo: 0, hour: 21)),
                .init(userInput: "AirPods", platform: .mercari, date: date(daysAgo: 1, hour: 9)),
                .init(userInput: "iMac", platform: .amazon, date: date(daysAgo: 1, hour: 15)),
                .init(userInput: "Apple Pencil", platform: .youtube, date: date(daysAgo: 1, hour: 21)),
                .init(userInput: "MacBook Air", platform: .facebook, date: date(daysAgo: 2, hour: 9)),
                .init(userInput: "Xcode", platform: .google, date: date(daysAgo: 2, hour: 15)),
                .init(userInput: "Apple Watch", platform: .x, date: date(daysAgo: 2, hour: 21)),
                .init(userInput: "AirPods", platform: .rakuma, date: date(daysAgo: 3, hour: 9)),
                .init(userInput: "iPod touch", platform: .instagram, date: date(daysAgo: 3, hour: 15)),
                .init(userInput: "Apple Vision Pro", platform: .amazon, date: date(daysAgo: 3, hour: 21)),
                .init(userInput: "Safari", platform: .youtube, date: date(daysAgo: 4, hour: 9)),
                .init(userInput: "Tim Cook", platform: .facebook, date: date(daysAgo: 4, hour: 15)),
                .init(userInput: "iPhone SE", platform: .google, date: date(daysAgo: 4, hour: 21)),
                .init(userInput: "Apple Store", platform: .amazon, date: date(daysAgo: 5, hour: 9)),
                .init(userInput: "Steve Jobs", platform: .yahooFleaMarket, date: date(daysAgo: 5, hour: 15)),
                .init(userInput: "Apple Watch Ultra", platform: .google, date: date(daysAgo: 5, hour: 21)),
                .init(userInput: "iCloud", platform: .amazon, date: date(daysAgo: 6, hour: 9)),
                .init(userInput: "Apple Music", platform: .google, date: date(daysAgo: 6, hour: 15)),
                .init(userInput: "iOS 26", platform: .youtube, date: date(daysAgo: 6, hour: 21)),
                .init(userInput: "SwiftUI", platform: .x, date: date(daysAgo: 7, hour: 9)),
                .init(userInput: "Mac mini", platform: .amazon, date: date(daysAgo: 7, hour: 15)),
                .init(userInput: "AirTag", platform: .mercari, date: date(daysAgo: 7, hour: 21)),
                .init(userInput: "iPhoneケース", platform: .rakuma, date: date(daysAgo: 8, hour: 9)),
                .init(userInput: "iPad キーボード", platform: .yahooFleaMarket, date: date(daysAgo: 8, hour: 15)),
                .init(userInput: "Appleイベント", platform: .google, date: date(daysAgo: 8, hour: 21)),
                .init(userInput: "HomePod", platform: .amazon, date: date(daysAgo: 9, hour: 9)),
                .init(userInput: "Apple TV", platform: .youtube, date: date(daysAgo: 9, hour: 15)),
                .init(userInput: "Vision Pro", platform: .instagram, date: date(daysAgo: 9, hour: 21)),
                .init(userInput: "Magic Keyboard", platform: .mercari, date: date(daysAgo: 10, hour: 9)),
                .init(userInput: "AirPods Max", platform: .rakuma, date: date(daysAgo: 10, hour: 15)),
                .init(userInput: "MacBook Pro", platform: .google, date: date(daysAgo: 10, hour: 21)),
                .init(userInput: "iPhone 17", platform: .x, date: date(daysAgo: 11, hour: 9)),
                .init(userInput: "Apple Pay", platform: .facebook, date: date(daysAgo: 11, hour: 15)),
                .init(userInput: "Apple Pencil Pro", platform: .amazon, date: date(daysAgo: 11, hour: 21)),
                .init(userInput: "Mac Studio", platform: .google, date: date(daysAgo: 12, hour: 9)),
                .init(userInput: "iPad Air", platform: .instagram, date: date(daysAgo: 12, hour: 15)),
                .init(userInput: "Apple One", platform: .youtube, date: date(daysAgo: 12, hour: 21)),
                .init(userInput: "iCloud+", platform: .google, date: date(daysAgo: 13, hour: 9)),
                .init(userInput: "Apple Watch バンド", platform: .mercari, date: date(daysAgo: 13, hour: 15)),
                .init(userInput: "Safari 拡張機能", platform: .x, date: date(daysAgo: 13, hour: 21)),
                .init(userInput: "Final Cut Pro", platform: .youtube, date: date(daysAgo: 14, hour: 9)),
                .init(userInput: "Logic Pro", platform: .amazon, date: date(daysAgo: 14, hour: 15)),
                .init(userInput: "Apple Books", platform: .google, date: date(daysAgo: 14, hour: 21)),
                .init(userInput: "Apple Arcade", platform: .facebook, date: date(daysAgo: 15, hour: 9)),
                .init(userInput: "Apple Maps", platform: .googleMaps, date: date(daysAgo: 15, hour: 15)),
                .init(userInput: "Beats Studio Pro", platform: .amazon, date: date(daysAgo: 15, hour: 21)),
                .init(userInput: "Apple Store 渋谷", platform: .googleMaps, date: date(daysAgo: 16, hour: 9)),
                .init(userInput: "iPhoneアクセサリ", platform: .yahooFleaMarket, date: date(daysAgo: 16, hour: 15)),
            ]
        }
    }
}
