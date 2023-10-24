//
//  ViewModel.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/03.
//

import SwiftUI


// ビューモデル
class ViewModel: ObservableObject {
    static let shared = ViewModel()
    private init() {}
    
    // SettingsViewで使用
    @AppStorage("autoFocus") var settingAutoFocus = true
    @AppStorage("searchButton_Left") var settingLeftSearchButton = false
    @Published var keyboardToolbarButtons = KeyboardToolbarButtonsModel()
    
    // ビュープロパティ
    @Published var isPresesntedSettingsView = false
    @Published var isShowInstagramErrorAlert = false
    @Published var isShowPromptToConfirmDeletionOFAllHistorys = false
    
    // 検索機能
    private let searcher = SearcherModel()
    
    // 検索候補
    @Published var suggestionModel = SuggestionModel()
    var suggestions: [String] { return suggestionModel.suggestions }
    
    // 履歴管理
    @Published var historyModel = HistorysModel()
    var historys: [History] { historyModel.historys }
    
    // 日付管理
    private let dateFormatter = SADateFormatter.shared
    func getStringDate(from date: Date) -> String {
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
}


// 検索機能
extension ViewModel {
    // 入力から検索 or Suggestionから検索 or 履歴から検索 or ツールバーボタンから検索
    func Search(_ input: String, platform: Platform = .google) {
        do {
            try searcher.Search(input, platform: platform)
            addHistory(input: input, platform: platform)
        } catch {
            switch error {
            case HumanError.noInput:
                break
            case HumanError.whiteSpace:
                isShowInstagramErrorAlert = true
            default:
                fatalError()
            }
        }
    }
}


// 検索候補
extension ViewModel {
    // 検索候補を取得
    @MainActor func getSuggestion(from input: String) async throws {
        try await suggestionModel.fetchSuggestions(from: input)
    }
}


// 履歴管理
extension ViewModel {
    // 履歴を追加
    private func addHistory(input: String, platform: Platform) {
        historyModel.add(input: input, platform: platform)
    }
    
    // 任意の履歴を削除
    func removeHistory(at index: Int) {
        historyModel.remove(at: index)
    }

    // 全ての履歴を削除
    func removeAllHistorys() {
        historyModel.removeAll()
    }
}

