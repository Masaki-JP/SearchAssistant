extension SettingsView {
    func loadValidKeyboardToolbarButtons() {
        do {
            validKeyboardToolbarButtons = try validKeyboardToolbarButtonRepository.load()
        } catch ValidKeyboardToolbarButtonRepository.ValidKeyboardToolbarButtonRepositoryError.dataNotSet {
            validKeyboardToolbarButtons = SearchPlatform.allCases
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = SearchPlatform.allCases
        }
    }
    
    func toggleToolbarButtonAvailability(_ platform: SearchPlatform) {
        let previousState = validKeyboardToolbarButtons
        if validKeyboardToolbarButtons.contains(platform) {
            validKeyboardToolbarButtons.removeAll { $0 == platform }
        } else {
            validKeyboardToolbarButtons.append(platform)
        }
        do {
            try validKeyboardToolbarButtonRepository.save(validKeyboardToolbarButtons)
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = previousState
        }
    }
}
