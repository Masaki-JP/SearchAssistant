import Foundation

extension UserDefaultsKey {
    /// rawValue は @AppStorage のキー文字列として使用される。
    /// 
    enum AppStorageKey: String {
        case autoFocus
        case colorScheme
        case openInSafariView
        case historyMaximumCount
    }
    
    enum AppStorageDefaultValue {
        static let autoFocus = true
        static let openInSafariView = false
    }
}
