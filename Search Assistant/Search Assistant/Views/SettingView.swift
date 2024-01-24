import SwiftUI

struct SettingView: View {
    @StateObject private var veiewModel = SettingViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                FocusControlSection(isOn: veiewModel.$settingAutoFocus)
                SearchButtonSection(isOn: veiewModel.$settingLeftSearchButton)
                ColorSchemeSection(selection: veiewModel.$appStorageColorScheme)
                BrowserSection(isOn: veiewModel.$openInSafariView)
                KeyboardToolbarSection(
                    keyboardToolbarValisButtons: veiewModel.keyboardToolbarValidButtons,
                    action: veiewModel.toggleToolbarButtonAvailability
                )
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完了") { dismiss() }
                }
            }
        }
        // Close Automation
        .onChange(of: scenePhase) { newScene in
            guard newScene != .active else { return }
            dismiss()
        }
    }
}

#Preview {
    SettingView()
}
