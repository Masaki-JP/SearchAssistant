import SwiftUI

@MainActor
final class ContentViewModel: ObservableObject {
    ///
    ///
    ///
    /// 【Search History】
    ///
    /// - Important: 検索履歴の追加に失敗した場合は、そのまま処理を続行する。任意の検索履歴の削除、全ての検索履歴の削除を行う際は、処理前の状態を保持しておき、処理に失敗した場合に処理前の状態に戻す。
    ///
    /// 検索履歴
    @Published private(set) var historys: [SerachHistory] = []
    /// 検索履歴リポジトリ
    private let searchHistoryRepository = UserDefaultsRepository<[SerachHistory]>(key: .searchHistorys)
    /// 検索履歴を追加
    private func appendHistory(userInput: String, platform: SerchPlatform) {
        do {
            historys.insert(.init(userInput: userInput, platform: platform), at: 0)
            try searchHistoryRepository.save(historys)
        } catch {
            reportError(error)
        }
    }
    /// 任意の検索履歴を削除
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
    /// 全ての検索履歴を削除
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
        let url: URL; let id = UUID();
    }
    /// 検索用URLを作成するクラス
    private let searchURLCreater = SearchURLCreater()
    /// ユーザー入力とプラットフォームを受け取り、検索を行う関数
    func search(_ userInput: String, on platform: SerchPlatform) {
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
    @AppStorage(AppStorageKey.autoFocus) private(set) var settingAutoFocus = true
    /// 検索ボタンの位置の設定を保持する変数
    @AppStorage(AppStorageKey.searchButton_Left) private(set) var settingLeftSearchButton = false
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
    @Published private(set) var keyboardToolbarValidButtons = Set(SerchPlatform.allCases)
    /// キーボードツールバーボタンの有効無効を管理するクラス
    private let keyboardToolbarValidButtonRepository = UserDefaultsRepository<Set<SerchPlatform>>(key: UserDefaultsKey.keyboardToolbarValidButtons)
    /// 有効化されているキーボードツールバーボタンを取得する
    func fetchKeyboardToolbarValidButtons() {
        do {
            keyboardToolbarValidButtons = try keyboardToolbarValidButtonRepository.fetch()
        } catch {
            reportError(error)
            keyboardToolbarValidButtons = Set(SerchPlatform.allCases)
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
        /// 検索履歴の取得を行う
        do {
            historys = try searchHistoryRepository.fetch()
        } catch {
            reportError(error)
        }
        /// 保存されている有効化されているキーボードツールバーボタンを取得する
        /// 失敗時には全てのキーボードツールバーボタンを有効化する
        fetchKeyboardToolbarValidButtons()
    }
}
