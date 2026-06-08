import SwiftUI

struct SettingsView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    
    @AppStorage(AppStorageKey.autoFocus) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButton_Left) var settingLeftSearchButton = false
    @AppStorage(AppStorageKey.colorScheme) var appStorageColorScheme = ColorSchemeSetting.dark.rawValue
    @AppStorage(AppStorageKey.openInSafariView) var openInSafariView = true
    
    @State var validKeyboardToolbarButtons = Set(SearchPlatform.allCases)
    let validKeyboardToolbarButtonRepository = UserDefaultsRepository<Set<SearchPlatform>>(key: UserDefaultsKey.validKeyboardToolbarButtons)
    
    var body: some View {
        NavigationStack {
            List {
                FocusControlSection(isOn: $settingAutoFocus)
                SearchButtonSection(isOn: $settingLeftSearchButton)
                ColorSchemeSection(selection: $appStorageColorScheme)
                BrowserSection(isOn: $openInSafariView)
                KeyboardToolbarSection(validKeyboardToolbarButtons: validKeyboardToolbarButtons, action: toggleToolbarButtonAvailability)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完了") { dismiss() }
                }
            }
        }
        .onChange(of: scenePhase) { _, newScene in
            guard newScene != .active else { return }
            dismiss()
        }
        .onAppear(perform: fetchValidKeyboardToolbarButtons)
    }
}

#Preview {
    SettingsView()
}
