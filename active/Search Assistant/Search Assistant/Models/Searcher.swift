import SwiftUI

struct SearchDataForSafariView: Identifiable {
    let id = UUID()
    let url: URL

    init(_ userInput: String) {
        let query = userInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: Platform.google.prefixURL + query)!
        self.url = url
    }
}

final class Searcher {
    @AppStorage("openInSafariView") var openInSafariView = true
    var searchDataForSafariView: SearchDataForSafariView? = nil

    // 外部から呼ばれるのはこのメソッドのみ。プラットフォーム別の検索処理を行う。
    func Search(_ userInput: String, platform: Platform = .google) throws {
        switch platform {
        case .google where openInSafariView == true:
            searchDataForSafariView = .init(userInput)
        case .google where openInSafariView == false:
            try searchOnGoogle(userInput)
        case .google:
            fatalError()
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
}


// プラットフォームごとの検索処理。現在ではGoogle、Instagramのみが少し処理が異なる。
extension Searcher {
    // Google検索
    private func searchOnGoogle(_ input: String) throws {
        // 空文字はエラーを投げる
        guard !input.isEmpty else { throw HumanError.noInput }

        if let url = URL(string: input), UIApplication.shared.canOpenURL(url) {
            // URLを開く
            UIApplication.shared.open(url)
        } else {
            // 通常の検索
            let encodedWord = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let encodedWord = encodedWord,
                  let url = URL(string: Platform.google.prefixURL + encodedWord)
            else { throw SearchError() }
            UIApplication.shared.open(url)
        }
    }
    // Twitter検索
    private func searchOnTwitter(_ input: String) throws {
        // 空文字でないことを確認
        guard !input.isEmpty else { throw HumanError.noInput }
        // Twitter検索用URLを作成
        guard let encodedWord = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: Platform.twitter.prefixURL + encodedWord)
        else { throw SearchError() }
        // 作成したURLを開く
        UIApplication.shared.open(url)
    }
    // Instagram検索
    private func searchOnInstagram(_ input: String) throws {
        // スペースが含まれていないことを確認（Instagram特有）
        guard !input.contains(" ") && !input.contains("　") else {
            throw HumanError.whiteSpace
        }
        // 空文字でないことを確認
        guard !input.isEmpty else { throw HumanError.noInput }
        // Instagram検索用URLを作成
        guard let encodedWord = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: Platform.instagram.prefixURL + encodedWord)
        else { throw SearchError() }
        // 作成したURLを開く
        UIApplication.shared.open(url)
    }
    // Amazon検索
    private func searchOnAmazon(_ input: String) throws {
        // 空文字でないことを確認
        guard !input.isEmpty else { throw HumanError.noInput }
        // Amazon検索用URLを作成
        guard let encodedWord = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: Platform.amazon.prefixURL + encodedWord)
        else { throw SearchError() }
        // 作成したURLを開く
        UIApplication.shared.open(url)
    }
    // YouTube検索
    private func searchOnYouTube(_ input: String) throws {
        // 空文字でないことを確認
        guard !input.isEmpty else { throw HumanError.noInput }
        // YouTube検索用URLを作成
        guard let encodedWord = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: Platform.youtube.prefixURL + encodedWord)
        else { throw SearchError() }
        // 作成したURLを開く
        UIApplication.shared.open(url)
    }
    // Facebook検索
    private func searchOnFacebook(_ input: String) throws {
        // 空文字でないことを確認
        guard !input.isEmpty else { throw HumanError.noInput }
        // Facebook検索用URLを作成
        guard let encodedWord = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: Platform.facebook.prefixURL + encodedWord)
        else { throw SearchError() }
        // 作成したURLを開く
        UIApplication.shared.open(url)
    }
    // メルカリ検索
    private func searchOnMercari(_ input: String) throws {
        // 空文字でないことを確認
        guard !input.isEmpty else { throw HumanError.noInput }
        // メルカリ検索用URLを作成
        guard let encodedWord = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: Platform.mercari.prefixURL + encodedWord)
        else { throw SearchError() }
        // 作成したURLを開く
        UIApplication.shared.open(url)
    }
    // ラクマ検索
    private func searchOnRakuma(_ input: String) throws {
        // 空文字でないことを確認
        guard !input.isEmpty else { throw HumanError.noInput }
        // ラクマ検索用URLを作成
        guard let encodedWord = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: Platform.rakuma.prefixURL + encodedWord)
        else { throw SearchError() }
        // 作成したURLを開く
        UIApplication.shared.open(url)
    }
    // PayPayフリマ検索
    private func searchOnPayPayFleaMarket(_ input: String) throws {
        // 空文字でないことを確認
        guard !input.isEmpty else { throw HumanError.noInput }
        // PayPayフリマ検索用URLを作成
        guard let encodedWord = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: Platform.paypayFleaMarket.prefixURL + encodedWord)
        else { throw SearchError() }
        // 作成したURLを開く
        UIApplication.shared.open(url)
    }
}
