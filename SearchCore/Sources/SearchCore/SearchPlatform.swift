public enum SearchPlatform: String, Codable, CaseIterable, Identifiable {
    
    /// rawValue はデコード、エンコードで使用しているため、開発開始時点の名称で固定する。
    ///
    case google = "Google"
    case x = "Twitter"
    case instagram = "Instagram"
    case amazon = "Amazon"
    case youtube = "YouTube"
    case facebook = "Facebook"
    case mercari = "メルカリ"
    case rakuma = "ラクマ"
    case yahooFleaMarket = "PayPayフリマ"
    case googleMaps = "Google Maps"
    case rakutenIchiba = "楽天市場"
    case yahooShopping = "Yahoo!ショッピング"
    case tabelog = "食べログ"
    case cookpad = "クックパッド"
    case chatGPT = "ChatGPT"
    case claude = "Claude"
    case grok = "Grok"
    
    public var id: Self { self }
    
    public var displayName: String {
        switch self {
        case .google: "Google"
        case .x: "X"
        case .instagram: "Instagram"
        case .amazon: "Amazon"
        case .youtube: "YouTube"
        case .facebook: "Facebook"
        case .mercari: "メルカリ"
        case .rakuma: "ラクマ"
        case .yahooFleaMarket: "Yahoo!フリマ"
        case .googleMaps: "Googleマップ"
        case .rakutenIchiba: "楽天市場"
        case .yahooShopping: "Yahoo!ショッピング"
        case .tabelog: "食べログ"
        case .cookpad: "クックパッド"
        case .chatGPT: "ChatGPT\u{202F}(Beta)"
        case .claude: "Claude\u{202F}(Beta)"
        case .grok: "Grok\u{202F}(Beta)"
        }
    }
    
    public var prefixURL: String {
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
        case .googleMaps: "https://www.google.com/maps/search/?api=1&query="
        case .rakutenIchiba: "https://search.rakuten.co.jp/search/mall/"
        case .yahooShopping: "https://shopping.yahoo.co.jp/search?p="
        case .tabelog: "https://tabelog.com/rstLst/?sk="
        case .cookpad: "https://cookpad.com/jp/search/"
        case .chatGPT: "https://chatgpt.com/?prompt="
        case .claude: "https://claude.ai/new?q="
        case .grok: "https://grok.com/?q="
        }
    }
    
    public var iconCharacter: String {
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
        case .googleMaps: "M"
        case .rakutenIchiba: "R"
        case .yahooShopping: "Y"
        case .tabelog: "T"
        case .cookpad: "C"
        case .chatGPT: "C"
        case .claude: "C"
        case .grok: "G"
        }
    }
    
    public var faviconResourceName: String {
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
        case .googleMaps: "google_maps"
        case .rakutenIchiba: "rakuten_ichiba"
        case .yahooShopping: "yahoo_shopping"
        case .tabelog: "tabelog"
        case .cookpad: "cookpad"
        case .chatGPT: "chatgpt"
        case .claude: "claude"
        case .grok: "grok"
        }
    }
}
