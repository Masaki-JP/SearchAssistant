import SearchCore
import SwiftUI

extension SettingsView {
    func loadEnabledSearchButtons() {
        do {
            enabledSearchButtons = try enabledSearchButtonsRepository.load()
        } catch {
            if error != .dataNotSet { reportError(error) }
            enabledSearchButtons = SearchPlatform.allCases
        }
    }
    
    func toggleSearchButtonEnabled(_ platform: SearchPlatform) {
        let previousState = enabledSearchButtons
        if enabledSearchButtons.contains(platform) {
            enabledSearchButtons.removeAll { $0 == platform }
        } else {
            enabledSearchButtons.append(platform)
        }
        do {
            try enabledSearchButtonsRepository.save(enabledSearchButtons)
            selectionSoundPlayer.play()
        } catch {
            reportError(error)
            enabledSearchButtons = previousState
        }
    }
    
    func onSearchButtonsMove(fromOffsets source: IndexSet, toOffset destination: Int) {
        let previousState = enabledSearchButtons
        enabledSearchButtons.move(fromOffsets: source, toOffset: destination)
        do {
            try enabledSearchButtonsRepository.save(enabledSearchButtons)
        } catch {
            reportError(error)
            enabledSearchButtons = previousState
        }
    }
}
