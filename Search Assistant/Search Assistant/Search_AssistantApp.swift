import SwiftUI

@main
struct Search_AssistantApp: App {
    @AppStorage("colorScheme") private var colorScheme = SAColorScheme.dark.rawValue
    @StateObject private var viewRouter = ViewRouter.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch viewRouter.selected {
                case .splashScreenView:
                    SplashScreenView()
                case .contentView:
                    ContentView()
                }
            }
            .preferredColorScheme(
                colorScheme == "System" ? .none : colorScheme == "Light" ? .light : .dark
            )
        }
    }
}
