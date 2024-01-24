import SwiftUI

final class SearchURLCreater {
    enum SearchURLCreaterError: Error {
        case noInput
        case inputContainsWhitespaceOnInstagramSearch
        case inputPercentEncodingFailure
        case creatingURLFailure
        case cannotOpenURL
    }

    func create(_ input: String, searchPlatform: SerchPlatform) throws -> URL {
        ///
        ///
        /// もしinputが有効なURLだった場合、そのままURLインスタンスを作成し、それを返す。
        if let url = URL(string: input), UIApplication.shared.canOpenURL(url) {
            return url
        }
        ///
        ///
        /// 入力が空文字でないことを確認
        guard input.isEmpty == false
        else { throw SearchURLCreaterError.noInput }
        ///
        ///
        /// Instagram検索特有の処理：半角空白、全角空白が含まれていないことを確認
        if searchPlatform == .instagram,
           input.contains(" ") || input.contains("　") {
            throw SearchURLCreaterError.inputContainsWhitespaceOnInstagramSearch
        }
        ///
        ///
        /// 入力のパーセントエンコーディング
        guard let percentEncodedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { throw SearchURLCreaterError.inputPercentEncodingFailure }
        ///
        ///
        /// URLの作成
        guard let url = URL(string: searchPlatform.prefixURL + percentEncodedInput)
        else { throw SearchURLCreaterError.creatingURLFailure }
        ///
        ///
        /// URLを開けるか否か確認
        guard UIApplication.shared.canOpenURL(url)
        else { throw SearchURLCreaterError.cannotOpenURL }
        ///
        ///
        /// 作成したURLを返す
        return url
    }
}
