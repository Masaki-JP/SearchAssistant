import SwiftUI

enum SearchPlatform: String, Codable, CaseIterable, Identifiable {
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

    var imageColor: Color {
        switch self {
        case .google: .blue
        case .x: Color(red: 0.25, green: 0.25, blue: 0.25)
        case .instagram: .pink
        case .amazon: .orange
        case .youtube: Color(red: 1.0, green: 0.0, blue: 0.0)
        case .facebook: .cyan
        case .mercari: .green
        case .rakuma: .green
        case .yahooFleaMarket: .green
        }
    }
}
