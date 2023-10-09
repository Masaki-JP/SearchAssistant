//
//  HistoryModel.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/03.
//

import SwiftUI

// ヒストリー構造体
struct History: Codable, Identifiable {
    let input: String
    let platform: Platform
    var date = Date()
    var id = UUID()
}


// ヒストリーズモデル
struct HistorysModel {
    var historys: [History]
    
    
    // 履歴を追加
    mutating func add(input: String, platform: Platform) {
        let history = History(input: input, platform: platform)
        historys.insert(history, at: 0)
        // UserDefaultsにも反映
        let json = try! JSONEncoder().encode(historys) // FIXME: try!
        UserDefaults.standard.set(json, forKey: "historys")
    }
    
    
    // 履歴を全て削除
    mutating func removeAll() {
        historys.removeAll()
        UserDefaults.standard.removeObject(forKey: "historys")
    }
    
    
    
    init() {
        // historysの初期化
        guard let data = UserDefaults.standard.data(forKey: "historys"),
              let historys = try? JSONDecoder().decode([History].self, from: data)
        else { self.historys = []; return;}
        self.historys = historys
        
        
//        // スクリーンショットを撮った時に使ったデータ
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy年MM月dd日"
//        let october15th = dateFormatter.date(from: "2023年10月15日")!
//        let october14th = dateFormatter.date(from: "2023年10月14日")!
//        let october13th = dateFormatter.date(from: "2023年10月13日")!
//        
//        let sampleHistorys: [History] = [
//            History(input: "iPhone 15 Pro", platform: .google, date: october15th),
//            History(input: "iPad Air 第6世代", platform: .mercari, date: october15th),
//            History(input: "Macbook 新型", platform: .youtube, date: october15th),
//            History(input: "プレミアリーグ 順位", platform: .twitter, date: october15th),
//            History(input: "名古屋港水族館", platform: .instagram, date: october14th),
//            History(input: "パソコン 計量 薄型", platform: .amazon, date: october14th),
//            History(input: "一人暮らし 費用 平均", platform: .google, date: october14th),
//            History(input: "Xcode 最新バージョン", platform: .twitter, date: october13th),
//            History(input: "スマートホーム 初心者", platform: .google, date: october13th),
//            History(input: "サーキュレーター 静音", platform: .amazon, date: october13th),
//            History(input: "DVDプレイヤー ブラック", platform: .paypayFleaMarket, date: october13th),
//            History(input: "ホワイトキャニオン", platform: .instagram, date: october13th),
//            
//        ]
//        self.historys = sampleHistorys
    }
}
