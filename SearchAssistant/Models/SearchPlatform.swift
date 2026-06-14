import SwiftUI

enum SearchPlatform: String, Codable, CaseIterable, Identifiable {
    
    // MARK: rawValue はデコード、エンコードで使用しているため、開発開始時点の名称で固定する。
    case google = "Google"
    case x = "Twitter"
    case instagram = "Instagram"
    case amazon = "Amazon"
    case youtube = "YouTube"
    case facebook = "Facebook"
    case mercari = "メルカリ"
    case rakuma = "ラクマ"
    case yahooFleaMarket = "PayPayフリマ"
    
    var id: Self { self }
    
    var displayName: String {
        switch self {
        case .google:
            "Google"
        case .x:
            "X"
        case .instagram:
            "Instagram"
        case .amazon:
            "Amazon"
        case .youtube:
            "YouTube"
        case .facebook:
            "Facebook"
        case .mercari:
            "メルカリ"
        case .rakuma:
            "ラクマ"
        case .yahooFleaMarket:
            "Yahoo!フリマ"
        }
    }
    
    var prefixURL: String {
        switch self {
        case .google: "https://www.google.co.jp/search?q="
        case .x: "https://x.com/search?q="
        case .instagram: "https://www.instagram.com/explore/tags/"
        case .amazon: "https://www.amazon.co.jp/s?k="
        case .youtube: "https://www.youtube.com/results?search_query="
        case .facebook: "https://www.facebook.com/public/"
        case .mercari: "https://jp.mercari.com/search?keyword="
        case .rakuma: "https://fril.jp/s?query="
        case .yahooFleaMarket: "https://paypayfleamarket.yahoo.co.jp/search/"
        }
    }
    
    var iconCharacter: String {
        switch self {
        case .google: "G"
        case .x: "X"
        case .instagram: "I"
        case .amazon: "A"
        case .youtube: "Y"
        case .facebook: "F"
        case .mercari: "M"
        case .rakuma: "R"
        case .yahooFleaMarket: "Y"
        }
    }
    
    var faviconResourceName: String {
        switch self {
        case .google: "google"
        case .x: "x"
        case .instagram: "instagram"
        case .amazon: "amazon"
        case .youtube: "youtube"
        case .facebook: "facebook"
        case .mercari: "mercari"
        case .rakuma: "rakuma"
        case .yahooFleaMarket: "yahoo_flea_market"
        }
    }
}
