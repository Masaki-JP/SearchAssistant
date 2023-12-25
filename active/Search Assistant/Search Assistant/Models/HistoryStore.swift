import SwiftUI

final class HistoryStore {
    private let userDefaultsKey = "historys"
    @Published var historys: [History] {
        didSet {
            saveHistorysToUserDefaults()
        }
    }
    static let shared = HistoryStore()
    private init() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let historys = try? JSONDecoder().decode([History].self, from: data)
        else { self.historys = []; return; }
        self.historys = historys
    }

    // 履歴を追加
    func add(userInput: String, platform: Platform) {
        let history = History(userInput: userInput, platform: platform)
        historys.insert(history, at: 0)
    }
    // 任意の履歴を削除
    func remove(atOffsets indexSet: IndexSet) {
        historys.remove(atOffsets: indexSet)
    }
    // 全ての履歴を削除
    func removeAll() {
        historys.removeAll()
    }
    // 履歴の更新をUserDefaultsに反映
    private func saveHistorysToUserDefaults() {
        let json = try! JSONEncoder().encode(historys)
        UserDefaults.standard.set(json, forKey: userDefaultsKey)
    }
}

//        // スクリーンショットを撮った時に使ったモックデータ
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy年MM月dd日"
//        let october15th = dateFormatter.date(from: "2023年10月15日")!
//        let october14th = dateFormatter.date(from: "2023年10月14日")!
//        let october13th = dateFormatter.date(from: "2023年10月13日")!
//
//        let sampleHistorys: [History] = [
//            History(userInput: "iPhone 15 Pro", platform: .google, date: october15th),
//            History(userInput: "iPad Air 第6世代", platform: .mercari, date: october15th),
//            History(userInput: "Macbook 新型", platform: .youtube, date: october15th),
//            History(userInput: "プレミアリーグ 順位", platform: .twitter, date: october15th),
//            History(userInput: "名古屋港水族館", platform: .instagram, date: october14th),
//            History(userInput: "パソコン 計量 薄型", platform: .amazon, date: october14th),
//            History(userInput: "一人暮らし 費用 平均", platform: .google, date: october14th),
//            History(userInput: "Xcode 最新バージョン", platform: .twitter, date: october13th),
//            History(userInput: "スマートホーム 初心者", platform: .google, date: october13th),
//            History(userInput: "サーキュレーター 静音", platform: .amazon, date: october13th),
//            History(userInput: "DVDプレイヤー ブラック", platform: .paypayFleaMarket, date: october13th),
//            History(userInput: "ホワイトキャニオン", platform: .instagram, date: october13th),
//
//        ]
//        self.historys = sampleHistorys
