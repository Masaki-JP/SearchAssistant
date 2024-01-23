import SwiftUI

final class SearchExecuter {
    @AppStorage("openInSafariView") var openInSafariView = true
    var safariViewURL: SafariViewURL? = nil

    struct SafariViewURL: Identifiable {
        let url: URL
        let id: UUID

        init(_ userInput: String) {
            let query = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: SASerchPlatform.google.prefixURL + query)!
            self.url = url
            self.id = UUID()
        }
    }

    enum SearchExecuterError: Error {
        case noUserInput
        case cannotOpenURL
        case userInputPercentEncodingFailure
        case creatingURLFailure
        case userInputContainsWhitespaceOnInstagramSearch
    }

    /// 外部に提供するプラットフォーム別の検索を行う関数
    func Search(_ userInput: String, on platform: SASerchPlatform) throws {
        switch platform {
        case .google where openInSafariView == true:
            safariViewURL = .init(userInput)
        case .google where openInSafariView == false:
            try searchOnGoogle(userInput)
        case .instagram: try searchOnInstagram(userInput)
        default: try defaultSearch(userInput, on: platform)
        }
    }

    /// Google検索を行う関数
    private func searchOnGoogle(_ userInput: String) throws {
        guard userInput.isEmpty == false
        else { throw SearchExecuterError.noUserInput }

        if let url = URL(string: userInput),
           UIApplication.shared.canOpenURL(url) {
            // userInputがURLとして有効なケース
            UIApplication.shared.open(url)
        } else {
            // 通常のケース
            guard let percentEncodedUserInput = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            else { throw SearchExecuterError.userInputPercentEncodingFailure }
            let urlString = SASerchPlatform.google.prefixURL + percentEncodedUserInput
            guard let url = URL(string: urlString)
            else { throw SearchExecuterError.creatingURLFailure }
            guard UIApplication.shared.canOpenURL(url)
            else { throw SearchExecuterError.cannotOpenURL }
            UIApplication.shared.open(url)
        }
    }

    /// Instagram検索を行う関数
    private func searchOnInstagram(_ userInput: String) throws {
        guard userInput.isEmpty == false
        else { throw SearchExecuterError.noUserInput }
        guard userInput.contains(" ") == false, // 半角空白確認
              userInput.contains("　") == false // 全角空白確認
        else { throw SearchExecuterError.userInputContainsWhitespaceOnInstagramSearch }
        guard let percentEncodedUserInput = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { throw SearchExecuterError.userInputPercentEncodingFailure }
        let urlString = SASerchPlatform.instagram.prefixURL + percentEncodedUserInput
        guard let url = URL(string: urlString)
        else { throw SearchExecuterError.creatingURLFailure }
        guard UIApplication.shared.canOpenURL(url)
        else { throw SearchExecuterError.cannotOpenURL }
        UIApplication.shared.open(url)
    }

    /// そのほかのプラットフォームでの検索を行う関数
    private func defaultSearch(_ userInput: String, on platform: SASerchPlatform) throws {
        guard userInput.isEmpty == false
        else { throw SearchExecuterError.noUserInput }
        guard let percentEncodedUserInput = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { throw SearchExecuterError.userInputPercentEncodingFailure }
        let urlString = platform.prefixURL + percentEncodedUserInput
        guard let url = URL(string: urlString)
        else { throw SearchExecuterError.userInputPercentEncodingFailure }
        guard UIApplication.shared.canOpenURL(url)
        else { throw SearchExecuterError.cannotOpenURL }
        UIApplication.shared.open(url)
    }
}
