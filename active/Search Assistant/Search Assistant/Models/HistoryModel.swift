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


//// ヒストリーズモデル
//struct HistorysModel {
//    var historys: [History] = []
//    
//
//    // 履歴を追加
//    mutating func add(input: String, platform: Platform) {
//        let history = History(input: input, platform: platform)
//        historys.append(history)
//    }
//    
//    // 全履歴を削除
//    func removeAll() {}
//}


// ヒストリーズモデル
struct HistorysModel {
    
    var historys: [History]
    
    init() {
        guard let data = UserDefaults.standard.data(forKey: "historys"),
              let historys = try? JSONDecoder().decode([History].self, from: data)
        else { self.historys = []; return;}
        
        self.historys = historys
    }
    
    // 履歴を追加
    mutating func add(input: String, platform: Platform) {
        let history = History(input: input, platform: platform)
        historys.append(history)
        // UserDefaultsにも反映
        let json = try! JSONEncoder().encode(historys) // FIXME: try!
        UserDefaults.standard.set(json, forKey: "historys")
    }
    
    // 履歴を全て削除
    mutating func removeAll() {
        historys.removeAll()
        UserDefaults.standard.removeObject(forKey: "historys")
    }
}
