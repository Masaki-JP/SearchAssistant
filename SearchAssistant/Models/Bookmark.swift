import Foundation
import SearchCore

struct Bookmark: Identifiable {
    let id = UUID()
    let userInput: String
    let platform: SearchPlatform
    
    static let samples: [Bookmark] = [
        .init(userInput: "Apple", platform: .google),
        .init(userInput: "iPhoneケース", platform: .amazon),
        .init(userInput: "SwiftUI", platform: .youtube),
    ]
}
