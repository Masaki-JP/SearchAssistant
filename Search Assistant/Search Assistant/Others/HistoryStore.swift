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