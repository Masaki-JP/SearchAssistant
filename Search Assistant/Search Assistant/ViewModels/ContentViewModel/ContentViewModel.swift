import SwiftUI

@MainActor
final class ContentViewModel: ContentViewModelProtocol {
    @Published var userInput = ""
    ///
    ///
    ///
    ///
    /// [Presentation]
    @Published var isPresentedSettingView = false
    @Published var isShowInstagramErrorAlert = false
    @Published var isShowPromptToConfirmDeletionOFAllHistorys = false
    ///
    ///
    ///
    ///
    /// [Settings]
    @AppStorage(AppStorageKey.autoFocus)
    private(set) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButton_Left)
    private(set) var settingLeftSearchButton = false
    @Published private(set) var keyboardToolbarValidButtons: Set<SASerchPlatform>
    ///
    ///
    ///
    ///
    /// [Historys]
    private let historyStore = HistoryStore.shared
    @Published private var _historys: [SASerachHistory] = []
    ///
    var historys: [HistoryInfo] {
        self._historys.map { history in
            HistoryInfo(
                userInput: history.userInput,
                platform: history.platform,
                dateString: self.dateFormatter.string(from: history.date),
                id: history.id
            )
        }
    }
    ///
    struct HistoryInfo: Identifiable {
        let userInput: String
        let platform: SASerchPlatform
        let dateString: String
        let id: UUID
    }



    private let dateFormatter: DateFormatter

    init() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        self.dateFormatter = dateFormatter

        do {
            keyboardToolbarValidButtons = try keyboardToolbarValidButtonManager.fetch()
        } catch {
            reportError(error)
            keyboardToolbarValidButtons = Set(SASerchPlatform.allCases)
        }
        historyStore.$historys
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$_historys)
    }

    // キーボードツールバー管理
    private let keyboardToolbarValidButtonManager = UserDefaultsRepository<Set<SASerchPlatform>>(key: UserDefaultsKey.keyboardToolbarValidButtons)

    func fetchKeyboardToolbarValidButtons() {
        do {
            keyboardToolbarValidButtons = try keyboardToolbarValidButtonManager.fetch()
        } catch {
            reportError(error)
            keyboardToolbarValidButtons = Set(SASerchPlatform.allCases)
        }
    }

    // 検索機能
    var searcher = Searcher()

    // 検索候補
    let suggestionFetcher = SuggestionFetcher.shared
    @Published var suggestions: [String]? = []

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
