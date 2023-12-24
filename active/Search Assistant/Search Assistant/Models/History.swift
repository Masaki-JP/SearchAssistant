import Foundation

struct History: Codable, Identifiable {
    let userInput: String
    let platform: Platform
    let date: Date
    let id: UUID

    init(userInput: String, platform: Platform) {
        self.userInput = userInput
        self.platform = platform
        self.date = Date()
        self.id = UUID()
    }
}
