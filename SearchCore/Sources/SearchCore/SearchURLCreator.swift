import Foundation

public struct SearchURLCreator {
    public enum SearchURLCreatorError: Error {
        case noInput
        case inputPercentEncodingFailure
        case creatingURLFailure
    }

    public init() {}

    public func create(_ input: String, searchPlatform: SearchPlatform) throws -> URL {
        var input = input

        if let url = URL(string: input), url.scheme != nil {
            return url.replacingHTTPWithHTTPS ?? url
        }

        guard input.isEmpty == false else {
            throw SearchURLCreatorError.noInput
        }

        if searchPlatform == .instagram {
            input.removeAll { $0 == " " || $0 == "　" }
        }

        guard let percentEncodedInput = input.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            throw SearchURLCreatorError.inputPercentEncodingFailure
        }

        guard let url = URL(string: searchPlatform.prefixURL + percentEncodedInput) else {
            throw SearchURLCreatorError.creatingURLFailure
        }

        return url
    }
}
