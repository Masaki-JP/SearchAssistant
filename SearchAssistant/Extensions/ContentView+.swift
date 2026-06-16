import SwiftUI
import SwiftData

extension ContentView {
    enum ContentViewState {
        case searchHistoryList
        case noSearchHistory
        case searchSuggestionList
        case noSearchSuggestion
        case searchSuggestionLoading
        case searchSuggestionNetworkError
    }
    
    func onAppear() {
        loadValidKeyboardToolbarButtons()
        
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
            isSuggestionFetchFailed = false
            inputUsedToFetchCurrentSuggestions = nil
            await fetchSuggestion(from: userInput)
        } else {
            suggestions = []
            isSuggestionFetchFailed = false
            inputUsedToFetchCurrentSuggestions = nil
        }
    }
    
    func onSettingsViewDismiss() {
        loadValidKeyboardToolbarButtons()
        guard settingAutoFocus == true else { return }
        isFocused = true
    }
    
    struct SafariViewURL: Identifiable {
        let url: URL
        let id = UUID()
    }
    
    func appendHistory(userInput: String, platform: SearchPlatform) {
        do {
            modelContext.insert(SearchHistory(userInput: userInput, platform: platform))
            try modelContext.save()
        } catch {
            reportError(error)
            modelContext.rollback()
        }
    }
    
    func removeHistory(atOffsets indexSet: IndexSet) {
        do {
            let historiesToDelete = indexSet.map { histories[$0] }
            historiesToDelete.forEach(modelContext.delete)
            try modelContext.save()
        } catch {
            reportError(error)
            modelContext.rollback()
        }
    }
    
    func removeAllHistories() {
        do {
            histories.forEach(modelContext.delete)
            try modelContext.save()
        } catch {
            reportError(error)
            modelContext.rollback()
        }
    }
    
    func fetchSuggestion(from userInput: String) async {
        do {
            let fetchedSuggestions = try await suggestionFetcher.fetch(from: userInput)
            guard Task.isCancelled == false else { return }
            
            suggestions = fetchedSuggestions
            isSuggestionFetchFailed = false
            inputUsedToFetchCurrentSuggestions = userInput
        } catch is CancellationError {
            return
        } catch {
            guard Task.isCancelled == false else { return }
            
            suggestions = []
            isSuggestionFetchFailed = true
            inputUsedToFetchCurrentSuggestions = nil
        }
    }
    
    func searchAction(_ userInput: String, on platform: SearchPlatform?) {
        let normalizedUserInput = userInput.split(whereSeparator: \.isWhitespace).joined(separator: " ")
        guard normalizedUserInput.isEmpty == false else { return }
        let platform = platform ?? .google
        
        do {
            let url = try searchURLCreator.create(normalizedUserInput, searchPlatform: platform)
            appendHistory(userInput: normalizedUserInput, platform: platform)
            self.userInput.removeAll()
            
            if openInSafariView == true {
                presentedSafariViewURL = SafariViewURL(url: url)
            } else {
                UIApplication.shared.open(url)
            }
        } catch {
            reportError(error)
        }
    }
    
    func loadValidKeyboardToolbarButtons() {
        do {
            validKeyboardToolbarButtons = try validKeyboardToolbarButtonRepository.load()
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = SearchPlatform.allCases
        }
    }
}
