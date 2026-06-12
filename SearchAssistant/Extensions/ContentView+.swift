import SwiftUI

extension ContentView {
    func onAppear() {
        do {
            histories = try searchHistoryRepository.fetch()
        } catch {
            reportError(error)
        }
        
        fetchValidKeyboardToolbarButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            guard settingAutoFocus == true,
                  isPresentedSettingsView == false,
                  isPresentedDeleteAllHistoriesAlert == false,
                  presentedSafariViewURL == nil
            else { return }
            
            isFocused = true
        }
    }
    
    func onScenePhaseChange(oldScene: ScenePhase, newScene: ScenePhase) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            guard newScene == .active,
                  settingAutoFocus == true,
                  isPresentedSettingsView == false,
                  isPresentedDeleteAllHistoriesAlert == false,
                  presentedSafariViewURL == nil
            else { return }
            
            isFocused = true
        }
    }
    
    func onIsPresentedSettingsViewChange() {
        if isPresentedSettingsView == true { isFocused = false }
    }
    
    func onUserInputChange() async {
        if userInput.isEmpty == false {
            await getSuggestion(from: userInput)
        } else {
            suggestions = []
            isSuggestionFetchFailed = false
        }
    }
    
    func onSettingsViewDismiss() {
        fetchValidKeyboardToolbarButtons()
        guard settingAutoFocus == true else { return }
        isFocused = true
    }
    
    struct SafariViewURL: Identifiable {
        let url: URL
        let id = UUID()
    }
    
    func appendHistory(userInput: String, platform: SearchPlatform) {
        let previousHistories = histories
        do {
            histories.insert(.init(userInput: userInput, platform: platform), at: 0)
            try searchHistoryRepository.save(histories)
        } catch {
            reportError(error)
            histories = previousHistories
        }
    }
    
    func removeHistory(atOffsets indexSet: IndexSet) {
        let previousHistories = histories
        do {
            histories.remove(atOffsets: indexSet)
            try searchHistoryRepository.save(histories)
        } catch {
            reportError(error)
            histories = previousHistories
        }
    }
    
    func removeAllHistories() {
        let previousHistories = histories
        do {
            histories.removeAll()
            try searchHistoryRepository.save(histories)
        } catch {
            reportError(error)
            histories = previousHistories
        }
    }
    
    func getSuggestion(from userInput: String) async {
        do {
            let fetchedSuggestions = try await suggestionFetcher.fetch(from: userInput)
            guard Task.isCancelled == false else { return }
            
            suggestions = fetchedSuggestions
            isSuggestionFetchFailed = false
        } catch is CancellationError {
            return
        } catch {
            guard Task.isCancelled == false else { return }
            
            suggestions = []
            isSuggestionFetchFailed = true
        }
    }
    
    func search(_ userInput: String, on platform: SearchPlatform) {
        let userInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines.union(CharacterSet(charactersIn: "　")))
        guard userInput.isEmpty == false else { return }
        
        do {
            let url = try searchURLCreator.create(userInput, searchPlatform: platform)
            appendHistory(userInput: userInput, platform: platform)
            self.userInput.removeAll()
            switch openInSafariView {
            case true:
                presentedSafariViewURL = SafariViewURL(url: url)
            case false:
                UIApplication.shared.open(url)
            }
        } catch {
            reportError(error)
        }
    }
    
    func fetchValidKeyboardToolbarButtons() {
        do {
            validKeyboardToolbarButtons = try validKeyboardToolbarButtonRepository.fetch()
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = SearchPlatform.allCases
        }
    }
}
