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
