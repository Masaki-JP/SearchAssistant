import SwiftUI

@MainActor
final class SettingViewModel: ObservableObject {
    @AppStorage(AppStorageKey.autoFocus) private(set) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButton_Left) private(set) var settingLeftSearchButton = false
    @AppStorage(AppStorageKey.colorScheme) private(set) var appStorageColorScheme = ColorSchemeSetting.dark.rawValue
    @AppStorage(AppStorageKey.openInSafariView) private(set) var openInSafariView = true
    @Published private(set) var validKeyboardToolbarButtons = Set(SerchPlatform.allCases)

    init() {
        fetchValidKeyboardToolbarButtons()
    }

    private let validKeyboardToolbarButtonRepository = UserDefaultsRepository<Set<SerchPlatform>>(key: UserDefaultsKey.validKeyboardToolbarButtons)

    private func saveValidKeyboardToolbarButtons() throws {
        try validKeyboardToolbarButtonRepository.save(validKeyboardToolbarButtons)
    }

    func fetchValidKeyboardToolbarButtons() {
        do {
            validKeyboardToolbarButtons = try validKeyboardToolbarButtonRepository.fetch()
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = Set(SerchPlatform.allCases)
        }
    }

    func toggleToolbarButtonAvailability(_ platform: SerchPlatform) {
        let previousState = validKeyboardToolbarButtons
        if validKeyboardToolbarButtons.contains(platform) {
            validKeyboardToolbarButtons.remove(platform)
        } else {
            validKeyboardToolbarButtons.insert(platform)
        }
        do {
            try validKeyboardToolbarButtonRepository.save(validKeyboardToolbarButtons)
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = previousState
        }
    }
}
