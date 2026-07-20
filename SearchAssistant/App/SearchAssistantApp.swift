import SwiftUI
import SwiftData

@main
struct SearchAssistantApp: App {
    @AppStorage(UserDefaultsKey.AppStorageKey.colorScheme.rawValue) var colorSchemeSetting = ColorSchemeSetting.defaultValue
    @StateObject var viewRouter = ViewRouter.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch viewRouter.currentView {
                case .splashScreenView:
                    SplashScreenView()
                case .contentView:
                    ContentView(enabledSearchButtonRepository: .standard)
                }
            }
            .preferredColorScheme(colorSchemeSetting.colorScheme)
            .animation(.default, value: viewRouter.currentView)
        }
        .modelContainer(for: SearchHistory.self, isAutosaveEnabled: false)
    }
}
