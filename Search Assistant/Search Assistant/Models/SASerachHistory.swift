import Foundation

struct SASerachHistory: Codable, Identifiable {
    let userInput: String
    let platform: SASerchPlatform
    let date: Date
    let id: UUID

    init(userInput: String, platform: SASerchPlatform) {
        self.userInput = userInput
        self.platform = platform
        self.date = Date()
        self.id = UUID()
    }
}
