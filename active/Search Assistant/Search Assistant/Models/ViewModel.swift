//
//  ViewModel.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/03.
//

import SwiftUI

final class ViewModel: ObservableObject {
    
    
    
    static let shared = ViewModel()
    private init() {
        historyStore.$historys
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$historys)
        
        suggestionStore.$suggestions
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$suggestions)
        suggestionStore.$fetchFailure
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$fetchFailure)
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
    let suggestionStore = SuggestionStore.shared
    @Published var suggestions: [String] = []
    @Published var fetchFailure = false
    
    
    
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
    
    
    
    // With SuggestionStore
    func getSuggestion(from input: String) async throws {
        try await suggestionStore.fetchSuggestions(from: input)
    }
    
    
    
    // With HistoryStore
    private func addHistory(input: String, platform: Platform) {
        historyStore.add(input: input, platform: platform)
    }
//    func removeHistory(at index: Int) {
//        historyStore.remove(at: index)
//    }
    func removeHistory(atOffsets indexSet: IndexSet) {
        historyStore.remove(atOffsets: indexSet)
    }
    func removeAllHistorys() {
        historyStore.removeAll()
    }
    
    
    
}

