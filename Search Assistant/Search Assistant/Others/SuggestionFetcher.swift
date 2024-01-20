import Foundation

/// ユーザー入力に基づいてGoogleの検索候補をフェッチするためのクラス
///
/// 使用例：
/// ```
/// let userInput = "apple"
/// let suggestionFetcher = SuggestionFetcher.shared
///
/// Task {
///     do {
///         let suggestions = try await suggestionFetcher.fetch(from: userInput)
///         print(suggestions)
///     } catch {
///         print(error)
///     }
/// }
/// ```
final class SuggestionFetcher {
    /// プライベートイニシャライザで外部でのインスタンスの作成を防ぎ、スタティックプロパティを通じてシングルトンインスタンスを提供する。
    static let shared = SuggestionFetcher()
    private init() {}

    /// ユーザー入力に基づいて提案を非同期的にフェッチします。
    ///
    /// - Parameters:
    ///   - userInput: 検索クエリとして使用するユーザー入力文字列。
    /// - Returns: 検索提案の文字列配列。
    /// - Throws: ネットワークリクエストに関連するエラー。
    ///
    /// 使用例：
    /// ```
    /// let userInput = "apple"
    /// let suggestionFetcher = SuggestionFetcher.shared
    ///
    /// Task {
    ///     do {
    ///         let suggestions = try await suggestionFetcher.fetch(from: userInput)
    ///         print(suggestions)
    ///     } catch {
    ///         print(error)
    ///     }
    /// }
    /// ```
    /// 出力例：
    /// ```
    /// ["apple", "apple watch", "apple store", "apple music", "apple 初売り 2024", "apple id", "apple watch バンド", "apple 初売り", "apple pay", "appleギフトカード"]
    /// ```
    func fetch(from userInput: String) async throws -> [String] {
        let url = createURL(from: userInput)
        let (data, _) = try await URLSession.shared.data(from: url)
        let xmlString = String(data: data, encoding: .shiftJIS)!
        let suggestions = convertXMLStringToArray(xmlString: xmlString)
        return suggestions
    }

    /// ユーザー入力から検索URLを作成する。
    ///
    /// - Parameter userInput: 検索クエリとして使用するユーザー入力文字列
    /// - Returns: 構築されたURL。
    private func createURL(from userInput: String) -> URL {
        let prefixURL = "https://www.google.com/complete/search?hl=ja&output=toolbar&q="
        let query = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: prefixURL + query)!
        return url
    }

    /// XML形式の文字列を文字列の配列に変換する。
    ///
    /// - Parameter xmlString: 変換するXML形式の文字列
    /// - Returns: 抽出された提案の文字列配列
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
}



//// About XML
//// https://softmoco.com/swift/swift-how-to-parse-xml.php
//// https://zenn.dev/toaster/articles/2510da8c704d63
//// https://k-icegreen.com/?p=4032
//// https://qiita.com/eito_2/items/8dc0c5ed48a353c2a1b2
//// https://jp-seemore.com/app/16108/
//
//class XMLParserManager: NSObject, XMLParserDelegate {
//    var suggestions: [String] = []
//    private var currentElement = ""
//
//    func parse(data: Data) -> [String] {
//        let parser = XMLParser(data: data)
//        parser.delegate = self
//        parser.parse()
//        return suggestions
//    }
//
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        currentElement = elementName
//        if elementName == "suggestion", let suggestion = attributeDict["data"] {
//            suggestions.append(suggestion)
//        }
//    }
//}
//
//let xmlString = "<?xml version=\"1.0\"?><toplevel><CompleteSuggestion><suggestion data=\"apple\"/></CompleteSuggestion><CompleteSuggestion><suggestion data=\"apple watch\"/></CompleteSuggestion><CompleteSuggestion><suggestion data=\"apple store\"/></CompleteSuggestion><CompleteSuggestion><suggestion data=\"apple music\"/></CompleteSuggestion></toplevel>"
//
//if let data = xmlString.data(using: .utf8) {
//    let parserManager = XMLParserManager()
//    let suggestions = parserManager.parse(data: data)
//    print(suggestions) // ["apple", "apple watch", "apple store", "apple music"]
//}
