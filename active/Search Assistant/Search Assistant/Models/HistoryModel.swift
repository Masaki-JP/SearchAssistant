//
//  HistoryModel.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/03.
//

import Foundation

// ヒストリー構造体
struct History: Codable, Identifiable {
    let input: String
    let platform: Platform
    var date = Date()
    var id = UUID()
}


// ヒストリーズモデル
struct HistorysModel {
    var historys: [History] = []
    
    // 履歴を追加
    mutating func add(input: String, platform: Platform) {
        let history = History(input: input, platform: platform)
        historys.append(history)
    }
    
    // 全履歴を削除
    func removeAll() {}
}
