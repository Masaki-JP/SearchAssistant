import Foundation

final class SuggestionStore {
    @Published private(set) var suggestions: [String] = []
    @Published private(set) var fetchFailure = false
    static let shared = SuggestionStore()
    private init() {}

    func fetchSuggestions(from input: String) async throws {
        fetchFailure = false

        let suggestionAPIURL = "https://www.google.com/complete/search?hl=ja&output=toolbar&q="
        let encodedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: suggestionAPIURL + encodedInput)!

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let xmlString = String(data: data, encoding: .shiftJIS)!
            let suggestions = convertXMLStringToArray(xmlString: xmlString)
            self.suggestions = suggestions
        } catch {
            fetchFailure = true
            self.suggestions = []
        }
    }
}

extension SuggestionStore {
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
