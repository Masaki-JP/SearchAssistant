import SwiftUI

@main
struct Search_AssistantApp: App {
    @AppStorage("colorScheme") private var appStorageColorScheme = SAColorScheme.dark.rawValue
    @StateObject private var viewRouter = ViewRouter.shared

    var body: some Scene {
        WindowGroup {
            Group {
                switch viewRouter.currentView {
                case .splashScreenView:
                    SplashScreenView()
                case .contentView:
                    ContentView()
                }
            }
            .preferredColorScheme({
                return switch self.appStorageColorScheme {
                case "Dark": .dark
                case "Light": .light
                default: .none
                }
            }())
        }
    }
}
