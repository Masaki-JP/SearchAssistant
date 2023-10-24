//
//  SuggestionModel.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/04.
//

import Foundation

// サジェスションモデル
struct SuggestionModel {
    var suggestions: [String] = []
    var fetchFailure = false
    
    // suggestionを更新する
    @MainActor mutating func updateSuggestion(with newSuggestions: [String]) {
        self.suggestions = newSuggestions
    }
    
    // Suggestionを取得する
    mutating func fetchSuggestions(from input: String) async throws {
//        suggestions = []
        fetchFailure = false
        
        // URLを作成
        let suggestionAPIURL = "https://www.google.com/complete/search?hl=ja&output=toolbar&q="
        let encodedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: suggestionAPIURL + encodedInput)!

        // API通信データを取得
        var data = Data()
        do {
            (data, _) = try await URLSession.shared.data(from: url)
        } catch {
            fetchFailure = true
            await updateSuggestion(with: [])
        }
        
        // Data型をString型に変換
        let dataText = String(data: data, encoding: .shiftJIS)!

        // suggestionsの作成
        let store = dataText.components(separatedBy: "<CompleteSuggestion><suggestion data=\"")
        var suggestions = [String]()
        for (index, element) in store.enumerated() {
            if index == 0 {
                continue
            } else if index == store.count-1 {
                suggestions.append(element.replacingOccurrences(of: "\"/></CompleteSuggestion></toplevel>", with: ""))
            } else {
                suggestions.append(element.replacingOccurrences(of: "\"/></CompleteSuggestion>", with: ""))
            }
        }

        // suggestionsを反映
        await updateSuggestion(with: suggestions)
    }
    
    
}
