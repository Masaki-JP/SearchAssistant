//
//  ViewModel.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/03.
//

import Foundation


// ビューモデル
class ViewModel: ObservableObject {
    static let shared = ViewModel()
    private init() {}
    
    // 検索機能
    private let searcher = SearcherModel()
    
    // 検索候補
    @Published var suggestionModel = SuggestionModel()
    var suggestions: [String] { return suggestionModel.suggestions }
    
    // 履歴管理
    @Published var historyModel = HistorysModel()
    var historys: [History] { historyModel.historys }
}


// 検索機能
extension ViewModel {
    // 入力から検索 or Suggestionから検索 or 履歴から検索 or ツールバーボタンから検索
    func Search(_ input: String, platform: Platform = .google) throws {
        try searcher.Search(input, platform: platform)
        addHistory(input: input, platform: platform)
    }
}


// 検索候補
extension ViewModel {
    // 検索候補を取得
    @MainActor func getSuggestion(from input: String) async throws {
        try await suggestionModel.getSuggestions(from: input)
    }
}


// 履歴管理
extension ViewModel {
    // 履歴を追加（ViewModel内でしか呼ぶことはないので、後でプライベートにする
    func addHistory(input: String, platform: Platform) {
        historyModel.add(input: input, platform: platform)
    }
}
