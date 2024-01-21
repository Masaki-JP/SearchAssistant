import SwiftUI

@MainActor
final class SettingViewModel: ObservableObject {
    @AppStorage(AppStorageKey.autoFocus)
    private(set) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButton_Left)
    private(set) var settingLeftSearchButton = false
    @AppStorage(AppStorageKey.colorScheme)
    private(set) var appStorageColorScheme = SAColorScheme.dark.rawValue
    @AppStorage(AppStorageKey.openInSafariView)
    private(set) var openInSafariView = true
}
