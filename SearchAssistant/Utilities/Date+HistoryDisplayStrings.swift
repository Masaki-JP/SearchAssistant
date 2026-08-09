import Foundation

extension Date {
    private static let timeFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        return dateFormatter
    }()
    
    private static let japaneseDateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日 HH:mm"
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        return dateFormatter
    }()
    
    /// HistorySectionの履歴詳細メニューにおける日時表示に使用する。
    var historyDisplayString: String {
        let calendar = Calendar.autoupdatingCurrent
        let timeString = Self.timeFormatter.string(from: self)
        let today = calendar.startOfDay(for: .now)
        let date = calendar.startOfDay(for: self)
        
        return if date == today {
            "今日 \(timeString)"
        } else if date == calendar.date(byAdding: .day, value: -1, to: today) {
            "昨日 \(timeString)"
        } else {
            Self.japaneseDateFormatter.string(from: self)
        }
    }
    
    private static let japaneseDayFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日（E）"
        dateFormatter.calendar = Calendar.autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter
    }()
    
    /// HistorySectionの履歴一覧における日付別セクションの見出しに使用する。
    var historySectionDisplayString: String {
        let calendar = Calendar.autoupdatingCurrent
        let today = calendar.startOfDay(for: .now)
        let date = calendar.startOfDay(for: self)
        
        return if date == today {
            "今日"
        } else if date == calendar.date(byAdding: .day, value: -1, to: today) {
            "昨日"
        } else if date == calendar.date(byAdding: .day, value: -2, to: today) {
            "一昨日"
        } else {
            Self.japaneseDayFormatter.string(from: self)
        }
    }
}
