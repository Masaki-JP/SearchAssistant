import Foundation

extension UserDefaultsKey {
    /// rawValue は @AppStorage のキー文字列として使用される。
    /// 
    enum AppStorageKey: String {
        case autoFocus
        case colorScheme
        case openInSafariView
        case historyMaximumCount
        case didMigrateSearchHistoriesToSwiftData
    }
}
