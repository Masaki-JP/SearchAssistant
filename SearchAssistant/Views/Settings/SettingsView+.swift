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
    
    func onSearchButtonsMove(fromOffsets source: IndexSet, toOffset destination: Int) {
        let previousState = enabledSearchButtons
        enabledSearchButtons.move(fromOffsets: source, toOffset: destination)
        do {
            try enabledSearchButtonRepository.save(enabledSearchButtons)
        } catch {
            reportError(error)
            enabledSearchButtons = previousState
        }
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
