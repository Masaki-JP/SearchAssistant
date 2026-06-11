import SwiftUI

@main
struct SearchAssistantApp: App {
    @AppStorage(AppStorageKey.colorScheme) var appStorageColorScheme = ColorSchemeSetting.dark.rawValue
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
        }
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
