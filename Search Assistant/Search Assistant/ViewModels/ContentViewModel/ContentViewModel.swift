import SwiftUI

@MainActor
final class ContentViewModel: ContentViewModelProtocol {
    ///
    ///
    ///
    /// 【Search History】
    ///
    /// ContentViewModel内部で保持する検索履歴
    @Published private(set) var historys: [SASerachHistory] = []
    /// 検索履歴を保管するためのクラス
    private let historyStore = HistoryStore.shared
    /// 検索履歴を追加する
    private func appendHistory(userInput: String, platform: SASerchPlatform) {
        historyStore.append(userInput: userInput, platform: platform)
    }
    /// 特定の検索履歴を削除する
    func removeHistory(atOffsets indexSet: IndexSet) {
        historyStore.remove(atOffsets: indexSet)
    }
    /// 全ての検索履歴を削除する
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
    /// 検索候補を保持する変数
    @Published private(set) var suggestions: [String]? = []
    /// 検索候補を取得するクラス
    private let suggestionFetcher = SuggestionFetcher.shared
    /// ユーザー入力から検索候補を取得する
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
    /// `SafariView`を表示する際にトリガーとなるアイテム
    struct SafariViewURL: Identifiable {
        let url: URL
        let id = UUID()
    }
    /// 検索用URLを作成するクラス
    private let searchURLCreater = SearchURLCreater()
    /// ユーザー入力とプラットフォームを受け取り、検索を行う関数
    func search(_ userInput: String, on platform: SASerchPlatform) {
        do {
            let url = try searchURLCreater.create(userInput, searchPlatform: platform)
            switch openInSafariView {
            case true:
                safariViewURL = SafariViewURL(url: url)
            case false:
                UIApplication.shared.open(url)
            }
            appendHistory(userInput: userInput, platform: platform)
            self.userInput.removeAll()
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
    ///
    ///
    ///
    ///
    ///
    /// 【Presentation】
    ///
    /// `SettingView`の表示状態を管理する変数
    @Published var isPresentedSettingView = false
    /// インスタグラムエラーアラートの表示状態を管理する変数
    @Published var isShowInstagramErrorAlert = false
    /// 全履歴削除の確認を行うプロンプトの表示状態を管理する変数
    @Published var isShowPromptToConfirmDeletionOFAllHistorys = false
    /// `SafariView`を表示する際にトリガーとなるアイテム
    var safariViewURL: SafariViewURL? = nil
    ///
    ///
    ///
    ///
    ///
    /// 【Settings】
    ///
    /// キーボードの自動表示の設定を保持する変数
    @AppStorage(AppStorageKey.autoFocus)
    private(set) var settingAutoFocus = true
    /// 検索ボタンの位置の設定を保持する変数
    @AppStorage(AppStorageKey.searchButton_Left)
    private(set) var settingLeftSearchButton = false
    /// 検索結果を`SafariView`で開くか否かの設定を保持する変数
    @AppStorage("openInSafariView") var openInSafariView = true
    ///
    ///
    ///
    ///
    ///
    /// 【Setting: KeyboardToolbarValidButton】
    ///
    /// 有効化されているキーボードツールバーボタンを保持する変数
    @Published private(set) var keyboardToolbarValidButtons: Set<SASerchPlatform>
    /// キーボードツールバーボタンの有効無効を管理するクラス
    private let keyboardToolbarValidButtonManager = UserDefaultsRepository<Set<SASerchPlatform>>(key: UserDefaultsKey.keyboardToolbarValidButtons)
    /// 有効化されているキーボードツールバーボタンを取得する
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
    /// テキストフィールドで用いるテキストを保持する変数
    @Published var userInput = ""
    ///
    ///
    ///
    ///
    ///
    /// 【Initializer】
    ///
    init() {
        /// 保存されている有効化されているキーボードツールバーボタンを取得する
        /// 失敗時には全てのキーボードツールバーボタンを有効化する
        do {
            keyboardToolbarValidButtons = try keyboardToolbarValidButtonManager.fetch()
        } catch {
            reportError(error)
            keyboardToolbarValidButtons = Set(SASerchPlatform.allCases)
        }
        /// historyStoreが保持するhistorysの変更を内部の_historys変数に伝播させる
        historyStore.$historys
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$historys)
    }
}
