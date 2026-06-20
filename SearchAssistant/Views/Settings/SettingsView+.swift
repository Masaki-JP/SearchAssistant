import SearchCore
import SwiftUI

extension SettingsView {
    func loadValidKeyboardToolbarButtons() {
        do {
            validKeyboardToolbarButtons = try validKeyboardToolbarButtonRepository.load()
        } catch {
            if error != .dataNotSet { reportError(error) }
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
            selectionSoundPlayer.play()
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = previousState
        }
    }
    
    func onKeyboardToolbarButtonsMove(fromOffsets source: IndexSet, toOffset destination: Int) {
        let previousState = validKeyboardToolbarButtons
        validKeyboardToolbarButtons.move(fromOffsets: source, toOffset: destination)
        do {
            try validKeyboardToolbarButtonRepository.save(validKeyboardToolbarButtons)
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = previousState
        }
    }
}
