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
}
