import SwiftUI

final class SearchExecuter {
    @AppStorage("openInSafariView") var openInSafariView = true
    var searchDataForSafariView: SafariViewURL? = nil
    ///
    ///
    ///
    ///
    ///
    ///
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
    ///
    ///
    ///
    ///
    enum SearchExecuterError: Error {
        case noUserInput
        case cannotOpenURL
        case userInputPercentEncodingFailure
        case creatingURLFailure
        case userInputContainsWhitespaceOnInstagramSearch
    }

    struct SearchError: Error {}
    ///
    ///
    ///
    ///
    ///
    /// 外部に提供するプラットフォーム別の検索を行う関数
    func Search(_ userInput: String, on platform: SASerchPlatform) throws {
        switch platform {
        case .google where openInSafariView == true:
            searchDataForSafariView = .init(userInput)
        case .google where openInSafariView == false:
            try searchOnGoogle(userInput)
        case .google: fatalError()
        case .instagram: try searchOnInstagram(userInput)
        default:
            try defaultSearch(userInput, on: platform)
        }
    }
    ///
    ///
    ///
    ///
    ///
    /// 以下はプラットフォーム別の検索を行う関数
    /// 現在ではGoogleとInstagramが特有の処理をもつ
    ///
    /// Google検索を行う関数
    private func searchOnGoogle(_ userInput: String) throws {
        guard !userInput.isEmpty else { throw SearchExecuterError.noUserInput }
        if let url = URL(string: userInput), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let encodedWord = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let encodedWord = encodedWord,
                  let url = URL(string: SASerchPlatform.google.prefixURL + encodedWord)
            else { throw SearchError() }
            UIApplication.shared.open(url)
        }
    }
    /// Instagram検索を行う関数
    private func searchOnInstagram(_ userInput: String) throws {
        // スペースが含まれていないことを確認（Instagram特有）
        guard !userInput.contains(" ") && !userInput.contains("　") else {
            throw SearchExecuterError.userInputContainsWhitespaceOnInstagramSearch
        }
        // 空文字でないことを確認
        guard !userInput.isEmpty else { throw SearchExecuterError.noUserInput }
        // Instagram検索用URLを作成
        guard let encodedWord = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: SASerchPlatform.instagram.prefixURL + encodedWord)
        else { throw SearchError() }
        // 作成したURLを開く
        UIApplication.shared.open(url)
    }












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
