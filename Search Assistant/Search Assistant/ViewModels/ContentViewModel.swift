import SwiftUI

fileprivate typealias ContentViewModelProtocol = ObservableObject & ViewModelForSuggestionList &  ViewModelForHistoryList

@MainActor
final class ContentViewModel: ContentViewModelProtocol {
    init() {
        historyStore.$historys
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$historys)
    }
    // SettingsViewで使用
    @AppStorage("autoFocus") private(set) var settingAutoFocus = true
    @AppStorage("searchButton_Left") private(set) var settingLeftSearchButton = false
    @Published var keyboardToolbarButtons = KeyboardToolbarButtonsModel()
    // ビュープロパティ
    @Published var userInput = ""
    @Published var isPresentedSettingView = false
    @Published var isShowInstagramErrorAlert = false
    @Published var isShowPromptToConfirmDeletionOFAllHistorys = false

    // 検索機能
    var searcher = Searcher()

    // 検索候補
    let suggestionFetcher = SuggestionFetcher.shared
    @Published var suggestions: [String]? = []

    // 履歴管理
    let historyStore = HistoryStore.shared
    @Published var historys: [SASerachHistory] = []
    // 日付管理
    private let dateFormatter = SADateFormatter.shared
    func getDateString(from date: Date) -> String {
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

extension ContentViewModel {
    // With Searcher
    func search(_ userInput: String, on platform: SASerchPlatform) {
        do {
            try searcher.Search(userInput, on: platform)
            addHistory(userInput: userInput, platform: platform)
            self.userInput.removeAll()
        } catch {
            switch error {
            case HumanError.noUserInput:
                break
            case HumanError.whiteSpace:
                isShowInstagramErrorAlert = true
            default:
                fatalError()
            }
        }
    }
    // With SuggestionStore
    func getSuggestion(from userInput: String) async {
        do {
            try await suggestions = suggestionFetcher.fetch(from: userInput)
        } catch {
            suggestions = nil
        }
    }
    // With HistoryStore
    private func addHistory(userInput: String, platform: SASerchPlatform) {
        historyStore.add(userInput: userInput, platform: platform)
    }
    func removeHistory(atOffsets indexSet: IndexSet) {
        historyStore.remove(atOffsets: indexSet)
    }
    func removeAllHistorys() {
        historyStore.removeAll()
    }
}
