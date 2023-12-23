import Foundation

final class SADateFormatter {
    static let shared = SADateFormatter()
    private let dateFormatter: DateFormatter

    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
    }
    
    func string(from date: Date) -> String {
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
