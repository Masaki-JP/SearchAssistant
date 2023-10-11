//
//  Class_MySearcher.swift
//  Search Assistant
//
//  Created by 土井正貴 on 2022/12/22.
//

import SwiftUI


enum humanErrorOnMySearcher: Error {
    case void
    case whitespaceError
}

struct SearchHistory: Codable, Identifiable, Hashable {
    var id = UUID()
    let input: String
    let platform: SearchPlatform
    var date = Date()
}

enum SearchPlatform: Codable {
    case google
    case twitter
    case instagram
    case amazon
    case youtube
    case facebook
    case mercari
    case rakuma
    case paypayFleaMarket
}

class MySearcher: ObservableObject {
    
    private let googleSearchUrl = "https://www.google.co.jp/search?q="
    private let googleSuggestionApiUrl = "https://www.google.com/complete/search?hl=ja&output=toolbar&q="
    private let twitterSearchUrl = "https://twitter.com/search?q="
    private let instagramSearchUrl = "https://www.instagram.com/explore/tags/"
    private let amazonSearchUrl = "https://www.amazon.co.jp/s?k="
    private let youtubeSearchUrl = "https://www.youtube.com/results?search_query="
    private let facebookSearchURL = "https://www.facebook.com/public/"
    private let mercariSearchURL = "https://jp.mercari.com/search?keyword="
    private let rakumaSearchURL = "https://fril.jp/s?query="
    private let paypayFleamarketSearchURL = "https://paypayfleamarket.yahoo.co.jp/search/"

    
    @Published var searchHistorys = try! JSONDecoder().decode([SearchHistory].self, from: UserDefaults.standard.data(forKey: "searchHistorysData") ?? JSONEncoder().encode([SearchHistory]()))
    
    
    // 検索した履歴のプラットフォームを返す
    func getPlatform(searchHistory: SearchHistory) -> String {
        
        switch searchHistory.platform {
        case .google:
            return "Google"
        case .twitter:
            return "Twitter"
        case .instagram:
            return "Instagram"
        case .amazon:
            return "Amazon"
        case .youtube:
            return "YouTube"
        case .facebook:
            return "Facebook"
        case .mercari:
            return "メルカリ"
        case .rakuma:
            return "ラクマ"
        case .paypayFleaMarket:
            return "PayPayフリマ"
        }
    }
    

    // Google Suggestionを取得するメソッド
    func getGoogleSuggestions(searchWord: String) async throws -> [String] {

        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: googleSuggestionApiUrl + encodedSearchWord)!

        var data = Data()

        do {
            (data, _) = try await URLSession.shared.data(from: url)

        } catch {
            throw error
        }

        let dataText = String(data: data, encoding: .shiftJIS)!

        let store = dataText.components(separatedBy: "<CompleteSuggestion><suggestion data=\"")

        var suggestions = [String]()

        for (index, element) in store.enumerated() {
            if index == 0 {
                continue
            } else if index == store.count-1 {
                suggestions.append(element.replacingOccurrences(of: "\"/></CompleteSuggestion></toplevel>", with: ""))
            } else {
                suggestions.append(element.replacingOccurrences(of: "\"/></CompleteSuggestion>", with: ""))
            }
        }

        return suggestions
    }
    
    
    // 履歴からの検索
    func searchAgain(searchHistory: SearchHistory) {
        
        do {
            switch searchHistory.platform {
            case .google:
                try searchOnGoogle(searchWord: searchHistory.input)
            case .twitter:
                try searchOnTwitter(searchWord: searchHistory.input)
            case .instagram:
                try searchOnInstagram(searchWord: searchHistory.input)
            case .amazon:
                try searchOnAmazon(searchWord: searchHistory.input)
            case .youtube:
                try searchOnYouTube(searchWord: searchHistory.input)
            case .facebook:
                try searchOnFacebook(searchWord: searchHistory.input)
            case .mercari:
                try searchOnMercari(searchWord: searchHistory.input)
            case .rakuma:
                try searchOnRakuma(searchWord: searchHistory.input)
            case .paypayFleaMarket:
                try searchOnPayPayFleaMarket(searchWord: searchHistory.input)
            }
        } catch {
            print("error:", error)
            fatalError()
        }
        
        removeSearchHistory(searchHistory: searchHistory)
    }
    
    
    
    // 履歴の削除
    func removeSearchHistory(searchHistory: SearchHistory) {
        
        for i in searchHistorys.indices {
            if searchHistorys[i].id == searchHistory.id {
                searchHistorys.remove(at: i)
                break
            }
        }
        
        updateUserDefaultSearchHistorys()
    }
    
    // searchHistorysの変更をUserDefaultsに反映させる
    func updateUserDefaultSearchHistorys() {
        
        // searchHistorysの要素数を30に調整
        if searchHistorys.count == 31 {
            searchHistorys.removeFirst()
        } else if searchHistorys.count > 31 {
            searchHistorys.removeSubrange(30..<searchHistorys.count)
        }
        
        let searchHistorysData = try! JSONEncoder().encode(searchHistorys)
        UserDefaults.standard.set(searchHistorysData, forKey: "searchHistorysData")
    }
}

extension MySearcher {
    
    // Google検索(URLが入力されている場合はURLを開く)
    func searchOnGoogle(searchWord: String) throws {
        // 未実装
    }
    
    // Twitter検索
    func searchOnTwitter(searchWord: String) throws {
        
        guard searchWord != "" else {
            throw humanErrorOnMySearcher.void
        }
        
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        UIApplication.shared.open(URL(string: twitterSearchUrl + encodedSearchWord)!)
        
        
        let newSearchHistory = SearchHistory(input: searchWord, platform: SearchPlatform.twitter)
        searchHistorys.append(newSearchHistory)

        updateUserDefaultSearchHistorys()
    }
    
    
    // Instagram検索
    func searchOnInstagram(searchWord: String) throws {
        
        guard searchWord != "" else {
            throw humanErrorOnMySearcher.void
        }
        
        guard !searchWord.contains(" ") && !searchWord.contains("　") else {
            throw humanErrorOnMySearcher.whitespaceError
        }
        
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        UIApplication.shared.open(URL(string: instagramSearchUrl + encodedSearchWord)!)
        
        let newSearchHistory = SearchHistory(input: searchWord, platform: SearchPlatform.instagram)
        searchHistorys.append(newSearchHistory)

        updateUserDefaultSearchHistorys()
    }
    
    
    // Amazon検索
    func searchOnAmazon(searchWord: String) throws {
        
        guard searchWord != "" else {
            throw humanErrorOnMySearcher.void
        }
        
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        UIApplication.shared.open(URL(string: amazonSearchUrl + encodedSearchWord)!)
        
        let newSearchHistory = SearchHistory(input: searchWord, platform: SearchPlatform.amazon)
        searchHistorys.append(newSearchHistory)

        updateUserDefaultSearchHistorys()
    }
    
    
    // YouTube検索
    func searchOnYouTube(searchWord: String) throws {
        
        guard searchWord != "" else {
            throw humanErrorOnMySearcher.void
        }
        
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        UIApplication.shared.open(URL(string: youtubeSearchUrl + encodedSearchWord)!)
        
        let newSearchHistory = SearchHistory(input: searchWord, platform: SearchPlatform.youtube)
        searchHistorys.append(newSearchHistory)

        updateUserDefaultSearchHistorys()
    }
    
    // Facebook検索
    func searchOnFacebook(searchWord: String) throws {
        guard searchWord != "" else {
            throw humanErrorOnMySearcher.void
        }
        
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        UIApplication.shared.open(URL(string: facebookSearchURL + encodedSearchWord)!)
        
        let newSearchHistory = SearchHistory(input: searchWord, platform: SearchPlatform.facebook)
        searchHistorys.append(newSearchHistory)
        
        updateUserDefaultSearchHistorys()
    }
    
    // メルカリ検索
    func searchOnMercari(searchWord: String) throws {
        guard searchWord != "" else {
            throw humanErrorOnMySearcher.void
        }
        
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        UIApplication.shared.open(URL(string: mercariSearchURL + encodedSearchWord)!)
        
        let newSearchHistory = SearchHistory(input: searchWord, platform: SearchPlatform.mercari)
        searchHistorys.append(newSearchHistory)
        
        updateUserDefaultSearchHistorys()
    }
    
    // ラクマ検索
    func searchOnRakuma(searchWord: String) throws {
        guard searchWord != "" else {
            throw humanErrorOnMySearcher.void
        }
        
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        UIApplication.shared.open(URL(string: rakumaSearchURL + encodedSearchWord)!)
        
        let newSearchHistory = SearchHistory(input: searchWord, platform: SearchPlatform.rakuma)
        searchHistorys.append(newSearchHistory)
        
        updateUserDefaultSearchHistorys()
    }
    
    // PayPayフリマ検索
    func searchOnPayPayFleaMarket(searchWord: String) throws {
        guard searchWord != "" else {
            throw humanErrorOnMySearcher.void
        }
        
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        UIApplication.shared.open(URL(string: paypayFleamarketSearchURL + encodedSearchWord)!)
        
        let newSearchHistory = SearchHistory(input: searchWord, platform: SearchPlatform.paypayFleaMarket)
        searchHistorys.append(newSearchHistory)
        
        updateUserDefaultSearchHistorys()
    }
}


