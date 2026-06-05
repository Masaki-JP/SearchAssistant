extension SettingView {
    func fetchValidKeyboardToolbarButtons() {
        do {
            validKeyboardToolbarButtons = try validKeyboardToolbarButtonRepository.fetch()
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = Set(SearchPlatform.allCases)
        }
    }
    
    func toggleToolbarButtonAvailability(_ platform: SearchPlatform) {
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
