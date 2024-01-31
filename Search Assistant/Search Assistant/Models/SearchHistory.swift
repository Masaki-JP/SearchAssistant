import Foundation

struct SearchHistory: Codable, Identifiable {
    let userInput: String
    let platform: SerchPlatform
    let date: Date
    let id: UUID

    init(userInput: String, platform: SerchPlatform) {
        self.userInput = userInput
        self.platform = platform
        self.date = Date()
        self.id = UUID()
    }
}
