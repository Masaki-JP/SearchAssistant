import Foundation

final class SuggestionFetcher {
    static let shared = SuggestionFetcher()
    private init() {}

    func fetch(from userInput: String) async throws -> [String] {
        let url = createURL(from: userInput)
        let (data, _) = try await URLSession.shared.data(from: url)
        let xmlString = String(data: data, encoding: .shiftJIS)!
        let suggestions = convertXMLStringToArray(xmlString: xmlString)
        return suggestions
    }
}

private func createURL(from userInput: String) -> URL {
    let prefixURL = "https://www.google.com/complete/search?hl=ja&output=toolbar&q="
    let query = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: prefixURL + query)!
    return url
}

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
