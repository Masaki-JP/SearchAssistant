import SwiftUI

extension ContentView {
    private func appendHistory(userInput: String, platform: SearchPlatform) {
        do {
            historys.insert(.init(userInput: userInput, platform: platform), at: 0)
            try searchHistoryRepository.save(historys)
        } catch {
            reportError(error)
        }
    }

    func removeHistory(atOffsets indexSet: IndexSet) {
        let preHistorys = historys
        do {
            historys.remove(atOffsets: indexSet)
            try searchHistoryRepository.save(historys)
        } catch {
            reportError(error)
            historys = preHistorys
        }
    }

    func removeAllHistorys() {
        let preHistorys = historys
        do {
            historys.removeAll()
            try searchHistoryRepository.save(historys)
        } catch {
            reportError(error)
            historys = preHistorys
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
            let url = try searchURLCreater.create(userInput, searchPlatform: platform)
            appendHistory(userInput: userInput, platform: platform)
            self.userInput.removeAll()
            switch openInSafariView {
            case true:
                safariViewURL = SafariViewURL(url: url)
            case false:
                UIApplication.shared.open(url)
            }
        } catch {
            guard let error = error as? SearchURLCreater.SearchURLCreaterError
            else { reportError(error); return; }
            switch error {
            case .inputContainsWhitespaceOnInstagramSearch:
                isShowInstagramErrorAlert = true
            case .noInput, .inputPercentEncodingFailure, .creatingURLFailure, .cannotOpenURL:
                reportError(error)
            }
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
