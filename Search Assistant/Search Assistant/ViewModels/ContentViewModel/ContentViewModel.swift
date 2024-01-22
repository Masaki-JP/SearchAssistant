import SwiftUI

@MainActor
final class ContentViewModel: ContentViewModelProtocol {
    ///
    ///
    ///
    ///
    ///
    /// 【Search History】
    ///
    @Published private var _historys: [SASerachHistory] = []
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

    struct HistoryInfo: Identifiable {
        let userInput: String
        let platform: SASerchPlatform
        let dateString: String
        let id: UUID
    }

    private let historyStore = HistoryStore.shared

    private func appendHistory(userInput: String, platform: SASerchPlatform) {
        historyStore.append(userInput: userInput, platform: platform)
    }

    func removeHistory(atOffsets indexSet: IndexSet) {
        historyStore.remove(atOffsets: indexSet)
    }

    func removeAllHistorys() {
        historyStore.removeAll()
    }
    ///
    ///
    ///
    ///
    ///
    /// 【Search Suggestion】
    ///
    @Published private(set) var suggestions: [String]? = []
    private let suggestionFetcher = SuggestionFetcher.shared

    func getSuggestion(from userInput: String) async {
        do {
            try await suggestions = suggestionFetcher.fetch(from: userInput)
        } catch {
            suggestions = nil
        }
    }
    ///
    ///
    ///
    ///
    ///
    /// 【Search Executer】
    ///
    var searcher = Searcher()
    func search(_ userInput: String, on platform: SASerchPlatform) {
        do {
            try searcher.Search(userInput, on: platform)
            appendHistory(userInput: userInput, platform: platform)
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
    ///
    ///
    ///
    ///
    ///
    /// 【Presentation】
    ///
    @Published var isPresentedSettingView = false
    @Published var isShowInstagramErrorAlert = false
    @Published var isShowPromptToConfirmDeletionOFAllHistorys = false
    ///
    ///
    ///
    ///
    ///
    /// 【Settings】
    ///
    @AppStorage(AppStorageKey.autoFocus)
    private(set) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButton_Left)
    private(set) var settingLeftSearchButton = false
    ///
    ///
    ///
    ///
    ///
    /// 【Setting: KeyboardToolbarValidButton】
    ///
    @Published private(set) var keyboardToolbarValidButtons: Set<SASerchPlatform>
    private let keyboardToolbarValidButtonManager = UserDefaultsRepository<Set<SASerchPlatform>>(key: UserDefaultsKey.keyboardToolbarValidButtons)
    func fetchKeyboardToolbarValidButtons() {
        do {
            keyboardToolbarValidButtons = try keyboardToolbarValidButtonManager.fetch()
        } catch {
            reportError(error)
            keyboardToolbarValidButtons = Set(SASerchPlatform.allCases)
        }
    }
    ///
    ///
    ///
    ///
    ///
    /// 【Others】
    ///
    @Published var userInput = ""
    private let dateFormatter: DateFormatter
    ///
    ///
    ///
    /// 【Initializer】
    ///
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
}
