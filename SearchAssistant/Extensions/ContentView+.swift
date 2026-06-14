import SwiftUI

extension ContentView {
    typealias SearchHistoryRepository = UserDefaultsRepository<[SearchHistory]>
    typealias ValidKeyboardToolbarButtonRepository = UserDefaultsRepository<[SearchPlatform]>
    
    enum ContentViewState {
        case searchHistoryList
        case noSearchHistory
        case searchSuggestionList
        case noSearchSuggestion
        case searchSuggestionLoading
        case searchSuggestionNetworkError
    }
    
    func onAppear() {
        loadSearchHistories()
        
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
    
    func loadSearchHistories() {
        do {
            histories = try searchHistoryRepository.load()
        } catch {
            if let error = error as? SearchHistoryRepository.UserDefaultsRepositoryError,
               error != .dataNotFound {
                reportError(error)
            }
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
