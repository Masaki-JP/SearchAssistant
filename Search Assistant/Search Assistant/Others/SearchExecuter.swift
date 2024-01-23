import SwiftUI

final class SearchExecuter {
    @AppStorage("openInSafariView") var openInSafariView = true
    var searchDataForSafariView: SearchDataForSafariView? = nil
    ///
    ///
    ///
    ///
    ///
    ///
    struct SearchDataForSafariView: Identifiable {
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
        case .twitter: try searchOnTwitter(userInput)
        case .instagram: try searchOnInstagram(userInput)
        case .amazon: try searchOnAmazon(userInput)
        case .youtube: try searchOnYouTube(userInput)
        case .facebook: try searchOnFacebook(userInput)
        case .mercari: try searchOnMercari(userInput)
        case .rakuma: try searchOnRakuma(userInput)
        case .paypayFleaMarket: try searchOnPayPayFleaMarket(userInput)
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
    /// Twitter検索を行う関数
    private func searchOnTwitter(_ userInput: String) throws {
        guard !userInput.isEmpty else { throw SearchExecuterError.noUserInput }
        guard let encodedWord = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: SASerchPlatform.twitter.prefixURL + encodedWord)
        else { throw SearchError() }
        UIApplication.shared.open(url)
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
    /// Amazon検索を行う関数
    private func searchOnAmazon(_ userInput: String) throws {
        guard !userInput.isEmpty else { throw SearchExecuterError.noUserInput }
        guard let encodedWord = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: SASerchPlatform.amazon.prefixURL + encodedWord)
        else { throw SearchError() }
        UIApplication.shared.open(url)
    }
    /// YouTube検索を行う関数
    private func searchOnYouTube(_ userInput: String) throws {
        guard !userInput.isEmpty else { throw SearchExecuterError.noUserInput }
        guard let encodedWord = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: SASerchPlatform.youtube.prefixURL + encodedWord)
        else { throw SearchError() }
        UIApplication.shared.open(url)
    }
    /// Facebook検索を行う関数
    private func searchOnFacebook(_ userInput: String) throws {
        guard !userInput.isEmpty else { throw SearchExecuterError.noUserInput }
        guard let encodedWord = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: SASerchPlatform.facebook.prefixURL + encodedWord)
        else { throw SearchError() }
        UIApplication.shared.open(url)
    }
    /// メルカリ検索を行う関数
    private func searchOnMercari(_ userInput: String) throws {
        guard !userInput.isEmpty else { throw SearchExecuterError.noUserInput }
        guard let encodedWord = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: SASerchPlatform.mercari.prefixURL + encodedWord)
        else { throw SearchError() }
        UIApplication.shared.open(url)
    }
    /// ラクマ検索を行う関数
    private func searchOnRakuma(_ userInput: String) throws {
        guard !userInput.isEmpty else { throw SearchExecuterError.noUserInput }
        guard let encodedWord = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: SASerchPlatform.rakuma.prefixURL + encodedWord)
        else { throw SearchError() }
        UIApplication.shared.open(url)
    }
    /// PayPayフリマ検索を行う関数
    private func searchOnPayPayFleaMarket(_ userInput: String) throws {
        guard !userInput.isEmpty else { throw SearchExecuterError.noUserInput }
        guard let encodedWord = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: SASerchPlatform.paypayFleaMarket.prefixURL + encodedWord)
        else { throw SearchError() }
        UIApplication.shared.open(url)
    }
}
