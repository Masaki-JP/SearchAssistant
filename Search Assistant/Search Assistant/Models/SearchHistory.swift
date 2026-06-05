import Foundation

struct SearchHistory: Codable, Identifiable {
    let userInput: String
    let platform: SearchPlatform
    let date: Date
    let id: UUID

    init(userInput: String, platform: SearchPlatform) {
        self.userInput = userInput
        self.platform = platform
        self.date = Date()
        self.id = UUID()
    }
}
