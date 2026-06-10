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
    
    static let sample: Self = samples.first!
    
    static let samples: [Self] = [
        .init(userInput: "iPhone 15 Pro", platform: .google),
        .init(userInput: "iPad Pro", platform: .x),
        .init(userInput: "Studio Display", platform: .instagram),
        .init(userInput: "AirPods", platform: .mercari),
        .init(userInput: "iMac", platform: .amazon),
        .init(userInput: "Apple Pencil", platform: .youtube),
        .init(userInput: "MacBook Air", platform: .facebook),
        .init(userInput: "Xcode", platform: .google),
        .init(userInput: "Apple Watch", platform: .x),
        .init(userInput: "AirPods", platform: .rakuma),
        .init(userInput: "iPod touch", platform: .instagram),
        .init(userInput: "Apple Vision Pro", platform: .amazon),
        .init(userInput: "Safari", platform: .youtube),
        .init(userInput: "Tim Cook", platform: .facebook),
        .init(userInput: "iPhone SE", platform: .google),
        .init(userInput: "Apple Store", platform: .amazon),
        .init(userInput: "Steve Jobs", platform: .yahooFleaMarket),
        .init(userInput: "Apple Watch Ultra", platform: .google),
        .init(userInput: "iCloud", platform: .amazon),
        .init(userInput: "Apple Music", platform: .google),
    ]
}
