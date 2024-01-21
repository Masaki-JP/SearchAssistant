import SwiftUI

@main
struct Search_AssistantApp: App {
    @AppStorage("colorScheme") private var appStorageColorScheme = SAColorScheme.dark.rawValue
    @StateObject private var viewRouter = ViewRouter.shared
    @StateObject private var contentViewModel = ContentViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                switch viewRouter.currentView {
                case .splashScreenView:
                    SplashScreenView()
                case .contentView:
                    ContentView(vm: contentViewModel)
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

func reportError(
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line,
    _ error: Error
) {
    print("💥💥💥")
    print("fileID: \(fileID)")
    print("function: \(function)")
    print("line: \(line)")
    print("error: \(error) (\(type(of: error)))")
    print("💥💥💥")
}

func reportMockAction(
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
) {
    print("")
    print("Called MockAction")
    print("function: \(function)")
    print("line: \(line)")
    print("fileID: \(fileID)")
    print("")
}
