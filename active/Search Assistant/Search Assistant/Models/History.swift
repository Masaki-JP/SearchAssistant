import Foundation

struct History: Codable, Identifiable {
    let input: String
    let platform: Platform
    let date: Date
    let id: UUID

    init(input: String, platform: Platform) {
        self.input = input
        self.platform = platform
        self.date = Date()
        self.id = UUID()
    }
}
