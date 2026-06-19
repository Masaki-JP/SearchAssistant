import Foundation

/// Googleの検索候補XMLから候補文字列を取り出すパーサー。
///
/// Googleの検索候補APIは、検索候補を次のようなXMLで返します。
///
/// ```
/// <toplevel>
///     <CompleteSuggestion>
///         <suggestion data="apple" />
///     </CompleteSuggestion>
///     <CompleteSuggestion>
///         <suggestion data="apple watch" />
///     </CompleteSuggestion>
///     <CompleteSuggestion>
///         <suggestion data="apple store" />
///     </CompleteSuggestion>
/// </toplevel>
/// ```
///
/// このパーサーは、XML内の`<suggestion>`要素にある`data`属性を集めて、
/// `["apple", "apple watch", "apple store"]`のような文字列配列として返します。
///
/// 文字コードは通常のXMLとして一度解析し、失敗した場合はShift_JISとして読み直してから
/// UTF-8に変換して再解析します。どちらの方法でも`toplevel`要素が見つからない場合は、
/// Googleの検索候補XMLとして扱えないため`nil`を返します。
nonisolated final class SuggestionXMLParser: NSObject, XMLParserDelegate {
    private var suggestions: [String] = []
    private var didFindToplevelElement = false
    
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
