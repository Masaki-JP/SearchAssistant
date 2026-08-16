import Foundation
import SearchCore

struct Bookmark: Codable, Hashable, Identifiable {
    let id: UUID
    let userInput: String
    let platform: SearchPlatform
    
    init(id: UUID = .init(), userInput: String, platform: SearchPlatform) {
        self.id = id
        self.userInput = userInput
        self.platform = platform
    }
    
    static let samples: [Bookmark] = [
        .init(userInput: "Apple", platform: .google),
        .init(userInput: "iPhoneケース", platform: .amazon),
        .init(userInput: "SwiftUI", platform: .youtube),
    ]
}
