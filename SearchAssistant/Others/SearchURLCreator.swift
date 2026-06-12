import SwiftUI

final class SearchURLCreator {
    enum SearchURLCreatorError: Error {
        case noInput
        case inputPercentEncodingFailure
        case creatingURLFailure
        case cannotOpenURL
    }
    
    func create(_ input: String, searchPlatform: SearchPlatform) throws -> URL {
        var input = input

        if let url = URL(string: input), UIApplication.shared.canOpenURL(url) {
            return url
        }

        guard input.isEmpty == false else {
            throw SearchURLCreatorError.noInput
        }

        if searchPlatform == .instagram {
            input.replace("　", with: " ")
        }

        guard let percentEncodedInput = input.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            throw SearchURLCreatorError.inputPercentEncodingFailure
        }

        guard let url = URL(string: searchPlatform.prefixURL + percentEncodedInput) else {
            throw SearchURLCreatorError.creatingURLFailure
        }

        guard UIApplication.shared.canOpenURL(url) else {
            throw SearchURLCreatorError.cannotOpenURL
        }

        return url
    }
}
