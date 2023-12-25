import SwiftUI

final class ViewModel: ObservableObject {
    static let shared = ViewModel()
    private init() {
        historyStore.$historys
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$historys)
    }
    // SettingsViewで使用
    @AppStorage("autoFocus") var settingAutoFocus = true
    @AppStorage("searchButton_Left") var settingLeftSearchButton = false
    @Published var keyboardToolbarButtons = KeyboardToolbarButtonsModel()
    // ビュープロパティ
    @Published var isPresesntedSettingsView = false
    @Published var isShowInstagramErrorAlert = false
    @Published var isShowPromptToConfirmDeletionOFAllHistorys = false

    // 検索機能
    var searcher = Searcher()

    // 検索候補
    let suggestionFetcher = SuggestionFetcher.shared
    @Published var suggestions: [String]? = []

    // 履歴管理
    let historyStore = HistoryStore.shared
    @Published var historys: [History] = []
    // 日付管理
    private let dateFormatter = SADateFormatter.shared
    func getStringDate(from date: Date) -> String {
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
}

extension ViewModel {
    // With Searcher
    func search(_ userInput: String, platform: Platform = .google) {
        do {
            try searcher.Search(userInput, platform: platform)
            addHistory(userInput: userInput, platform: platform)
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
    @MainActor
    func getSuggestion(from userInput: String) async {
        do {
            try await suggestions = suggestionFetcher.fetch(from: userInput)
        } catch {
            suggestions = nil
        }
    }
    // With HistoryStore
    private func addHistory(userInput: String, platform: Platform) {
        historyStore.add(userInput: userInput, platform: platform)
    }
    func removeHistory(atOffsets indexSet: IndexSet) {
        historyStore.remove(atOffsets: indexSet)
    }
    func removeAllHistorys() {
        historyStore.removeAll()
    }
}
