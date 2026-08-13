import SearchCore
import SwiftUI
import SwiftData

extension SettingsView {
    func loadEnabledSearchButtons() {
        do {
            enabledSearchButtons = try enabledSearchButtonRepository.load()
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
            try enabledSearchButtonRepository.save(enabledSearchButtons)
            selectionSoundPlayer.play()
        } catch {
            reportError(error)
            enabledSearchButtons = previousState
        }
    }
    
    func onSearchButtonsBarOrderSaved(_ reorderedButtons: [SearchPlatform]) throws {
        try enabledSearchButtonRepository.save(reorderedButtons)
        enabledSearchButtons = reorderedButtons
    }
    
    func trimHistoriesIfNeeded() {
        do {
            try SearchHistory.trimIfNeeded(using: modelContext)
            try modelContext.save()
        } catch {
            modelContext.rollback()
        }
    }
}
