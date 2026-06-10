import SwiftUI

extension ContentView {
    struct SafariViewURL: Identifiable {
        let url: URL
        let id = UUID()
    }
    
    func appendHistory(userInput: String, platform: SearchPlatform) {
        do {
            histories.insert(.init(userInput: userInput, platform: platform), at: 0)
            try searchHistoryRepository.save(histories)
        } catch {
            reportError(error)
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
            try await suggestions = suggestionFetcher.fetch(from: userInput)
        } catch {
            suggestions = nil
        }
    }
    
    func search(_ userInput: String, on platform: SearchPlatform) {
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
            validKeyboardToolbarButtons = Set(SearchPlatform.allCases)
        }
    }
}
