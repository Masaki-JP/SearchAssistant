import SwiftUI
import SwiftData

@main
struct SearchAssistantApp: App {
    @AppStorage(UserDefaultsKey.AppStorageKey.colorScheme.rawValue) var appStorageColorScheme = ColorSchemeSetting.dark.rawValue
    @StateObject var viewRouter = ViewRouter.shared
    
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
            .preferredColorScheme(colorScheme)
            .animation(.default, value: viewRouter.currentView)
        }
        .modelContainer(for: SearchHistory.self, isAutosaveEnabled: false)
    }
    
    var colorScheme: ColorScheme? {
        switch appStorageColorScheme {
        case ColorSchemeSetting.dark.rawValue: .dark
        case ColorSchemeSetting.light.rawValue: .light
        case ColorSchemeSetting.system.rawValue: .none
        default: .none
        }
    }
}
