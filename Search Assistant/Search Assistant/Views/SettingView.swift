import SwiftUI

struct SettingView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage(AppStorageKey.autoFocus) private(set) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButton_Left) private(set) var settingLeftSearchButton = false
    @AppStorage(AppStorageKey.colorScheme) private(set) var appStorageColorScheme = ColorSchemeSetting.dark.rawValue
    @AppStorage(AppStorageKey.openInSafariView) private(set) var openInSafariView = true
    
    @State private var validKeyboardToolbarButtons = Set(SerchPlatform.allCases)
    
    private let validKeyboardToolbarButtonRepository = UserDefaultsRepository<Set<SerchPlatform>>(key: UserDefaultsKey.validKeyboardToolbarButtons)
    
    init() { fetchValidKeyboardToolbarButtons() }
    
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
        .onChange(of: scenePhase) { newScene in
            guard newScene != .active else { return }
            dismiss()
        }
    }
        
    func fetchValidKeyboardToolbarButtons() {
        do {
            validKeyboardToolbarButtons = try validKeyboardToolbarButtonRepository.fetch()
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = Set(SerchPlatform.allCases)
        }
    }
    
    func toggleToolbarButtonAvailability(_ platform: SerchPlatform) {
        let previousState = validKeyboardToolbarButtons
        if validKeyboardToolbarButtons.contains(platform) {
            validKeyboardToolbarButtons.remove(platform)
        } else {
            validKeyboardToolbarButtons.insert(platform)
        }
        do {
            try validKeyboardToolbarButtonRepository.save(validKeyboardToolbarButtons)
        } catch {
            reportError(error)
            validKeyboardToolbarButtons = previousState
        }
    }
}

#Preview {
    SettingView()
}
