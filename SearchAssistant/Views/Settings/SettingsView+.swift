import SearchCore
import SwiftUI

extension SettingsView {
    func loadEnabledKeyboardToolbarButtons() {
        do {
            enabledKeyboardToolbarButtons = try enabledKeyboardToolbarButtonRepository.load()
        } catch {
            if error != .dataNotSet { reportError(error) }
            enabledKeyboardToolbarButtons = SearchPlatform.allCases
        }
    }
    
    func toggleToolbarButtonAvailability(_ platform: SearchPlatform) {
        let previousState = enabledKeyboardToolbarButtons
        if enabledKeyboardToolbarButtons.contains(platform) {
            enabledKeyboardToolbarButtons.removeAll { $0 == platform }
        } else {
            enabledKeyboardToolbarButtons.append(platform)
        }
        do {
            try enabledKeyboardToolbarButtonRepository.save(enabledKeyboardToolbarButtons)
            selectionSoundPlayer.play()
        } catch {
            reportError(error)
            enabledKeyboardToolbarButtons = previousState
        }
    }
    
    func onKeyboardToolbarButtonsMove(fromOffsets source: IndexSet, toOffset destination: Int) {
        let previousState = enabledKeyboardToolbarButtons
        enabledKeyboardToolbarButtons.move(fromOffsets: source, toOffset: destination)
        do {
            try enabledKeyboardToolbarButtonRepository.save(enabledKeyboardToolbarButtons)
        } catch {
            reportError(error)
            enabledKeyboardToolbarButtons = previousState
        }
    }
}
