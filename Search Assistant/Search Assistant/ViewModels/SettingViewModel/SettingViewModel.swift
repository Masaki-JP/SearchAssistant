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
    @Published private(set) var keyboardToolbarValidButtons = Set(SASerchPlatform.allCases)

    init() {
        fetchKeyboardToolbarValidButtons()
    }

    private let keyboardToolbarValidButtonRepository = UserDefaultsRepository<Set<SASerchPlatform>>(key: UserDefaultsKey.keyboardToolbarValidButtons)

    private func saveKeyboardToolbarValidButton() throws {
        try keyboardToolbarValidButtonRepository.save(keyboardToolbarValidButtons)
    }

    func fetchKeyboardToolbarValidButtons() {
        do {
            keyboardToolbarValidButtons = try keyboardToolbarValidButtonRepository.fetch()
        } catch {
            reportError(error)
            keyboardToolbarValidButtons = Set(SASerchPlatform.allCases)
        }
    }

    func toggleToolbarButtonAvailability(_ platform: SASerchPlatform) {
        let preKeyboardToolbarValidButtons = keyboardToolbarValidButtons
        if keyboardToolbarValidButtons.contains(platform) {
            keyboardToolbarValidButtons.remove(platform)
        } else {
            keyboardToolbarValidButtons.insert(platform)
        }
        do {
            try keyboardToolbarValidButtonRepository.save(keyboardToolbarValidButtons)
        } catch {
            reportError(error)
            keyboardToolbarValidButtons = preKeyboardToolbarValidButtons
        }
    }
}
