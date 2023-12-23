import Foundation

final class SuggestionStore {
    static let shared = SuggestionStore()
    private init() {}
    
    @Published private(set) var suggestions: [String] = []
    @Published private(set) var fetchFailure = false
    
    // suggestionを更新する
    internal func update(with newSuggestions: [String]) {
        self.suggestions = newSuggestions
    }
    
    // Suggestionを取得する
    internal func fetchSuggestions(from input: String) async throws {
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
            update(with: []) // FIXME: 重複
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
        update(with: suggestions) // FIXME: 重複
    }
    
    
}
