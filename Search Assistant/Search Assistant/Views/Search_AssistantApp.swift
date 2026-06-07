import SwiftUI

@main
struct Search_AssistantApp: App {
    @AppStorage("colorScheme") private var appStorageColorScheme = ColorSchemeSetting.dark.rawValue
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
                case ColorSchemeSetting.dark.rawValue: .dark
                case ColorSchemeSetting.light.rawValue: .light
                case ColorSchemeSetting.system.rawValue: .none
                default: .none
                }
            }())
        }
    }
}
