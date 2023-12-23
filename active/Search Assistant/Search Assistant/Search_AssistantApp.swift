import SwiftUI

@main
struct Search_AssistantApp: App {
    @AppStorage("colorScheme") var colorScheme = ColorScheme.dark.rawValue
    @StateObject private var viewRouter = ViewRouter.shared
    @StateObject private var vm = ViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch viewRouter.selected {
                case .splashScreenView:
                    SplashScreenView()
                case .contentView:
                    ContentView(vm: vm)
                }
            }
            .preferredColorScheme(
                colorScheme == "System" ? .none : colorScheme == "Light" ? .light : .dark
            )
        }
    }
}
