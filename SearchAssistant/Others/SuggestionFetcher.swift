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
    static let shared = SuggestionFetcher()
    private init() {}
    
    enum FetchError: Error {
        case failedToEncodeQuery
        case failedToCreateURL
        case invalidResponse
        case unacceptableStatusCode(Int)
        case failedToParseResponse
    }
    
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
        let url = try createURL(from: userInput)
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw FetchError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw FetchError.unacceptableStatusCode(httpResponse.statusCode)
        }

        let parser = SuggestionXMLParser()
        guard let suggestions = parser.parse(data: data) else {
            throw FetchError.failedToParseResponse
        }

        return suggestions
    }
    
    private func createURL(from userInput: String) throws -> URL {
        let prefixURL = "https://www.google.com/complete/search?hl=ja&output=toolbar&q="
        guard let query = userInput.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            throw FetchError.failedToEncodeQuery
        }
        guard let url = URL(string: prefixURL + query) else {
            throw FetchError.failedToCreateURL
        }
        return url
    }
    
}

class SuggestionXMLParser: NSObject, XMLParserDelegate {
    var suggestions: [String] = []
    var didFindToplevelElement = false
    
    func parse(data: Data) -> [String]? {
        if parseXMLData(data), didFindToplevelElement == true {
            return suggestions
        }

        guard let xmlData = utf8DataFromShiftJISXML(data) else {
            return nil
        }

        if parseXMLData(xmlData), didFindToplevelElement == true {
            return suggestions
        }

        return nil
    }
    
    @discardableResult
    private func parseXMLData(_ data: Data) -> Bool {
        suggestions = []
        didFindToplevelElement = false

        let parser = XMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
    
    private func utf8DataFromShiftJISXML(_ data: Data) -> Data? {
        guard
            let xmlString = String(data: data, encoding: .shiftJIS),
            let utf8Data = xmlString.data(using: .utf8)
        else {
            return nil
        }

        return utf8Data
    }
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        if elementName == "toplevel" {
            didFindToplevelElement = true
        }

        if elementName == "suggestion", let suggestion = attributeDict["data"] {
            suggestions.append(suggestion)
        }
    }
}
