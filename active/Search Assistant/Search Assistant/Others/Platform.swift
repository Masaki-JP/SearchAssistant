//
//  Platform.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/04.
//

import Foundation

enum Platform: String, Codable {
    case google = "Google"
    case twitter = "Twitter"
    case instagram = "Instagram"
    case amazon = "Amazon"
    case youtube = "YouTube"
    case facebook = "Facebook"
    case mercari = "メルカリ"
    case rakuma = "ラクマ"
    case paypayFleaMarket = "PayPayフリマ"
    
    var prefixURL: String {
        switch self {
        case .google: "https://www.google.co.jp/search?q="
        case .twitter: "https://twitter.com/search?q="
        case .instagram: "https://www.instagram.com/explore/tags/"
        case .amazon: "https://www.amazon.co.jp/s?k="
        case .youtube: "https://www.youtube.com/results?search_query="
        case .facebook: "https://www.facebook.com/public/"
        case .mercari: "https://jp.mercari.com/search?keyword="
        case .rakuma: "https://fril.jp/s?query="
        case .paypayFleaMarket: "https://paypayfleamarket.yahoo.co.jp/search/"
        }
    }
}
