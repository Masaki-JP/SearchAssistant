import Foundation

/// `SuggestionFetcher` は、ユーザー入力に基づいて提案をフェッチするためのクラスです。
final class SuggestionFetcher {
    /// シングルトンインスタンスを提供します。
    static let shared = SuggestionFetcher()
    /// プライベートイニシャライザは外部からのインスタンス化を防ぎます。
    private init() {}

    /// ユーザー入力に基づいて提案を非同期的にフェッチします。
    ///
    /// - Parameters:
    ///   - userInput: 検索クエリとして使用するユーザー入力文字列。
    /// - Returns: 検索提案の文字列配列。
    /// - Throws: ネットワークリクエストに関連するエラー。
    func fetch(from userInput: String) async throws -> [String] {
        let url = createURL(from: userInput)
        let (data, _) = try await URLSession.shared.data(from: url)
        let xmlString = String(data: data, encoding: .shiftJIS)!
        let suggestions = convertXMLStringToArray(xmlString: xmlString)
        return suggestions
    }
}

/// ユーザー入力から検索URLを作成します。
///
/// - Parameter userInput: 検索クエリとして使用するユーザー入力文字列。
/// - Returns: 構築されたURL。
private func createURL(from userInput: String) -> URL {
    let prefixURL = "https://www.google.com/complete/search?hl=ja&output=toolbar&q="
    let query = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: prefixURL + query)!
    return url
}

/// XML形式の文字列を文字列の配列に変換します。
///
/// - Parameter xmlString: 変換するXML形式の文字列。
/// - Returns: 抽出された提案の文字列配列。
private func convertXMLStringToArray(xmlString: String) -> [String] {
    var suggestions: [String] = .init()
    let unfinishedXmlElements = xmlString.components(separatedBy: "<CompleteSuggestion><suggestion data=\"")
    for (index, element) in xmlString.components(separatedBy: "<CompleteSuggestion><suggestion data=\"").enumerated() {
        if index == 0 {
            continue
        } else if index == unfinishedXmlElements.count-1 {
            suggestions.append(
                element.replacingOccurrences(of: "\"/></CompleteSuggestion></toplevel>", with: "")
            )
        } else {
            suggestions.append(
                element.replacingOccurrences(of: "\"/></CompleteSuggestion>", with: "")
            )
        }
    }
    return suggestions
}
