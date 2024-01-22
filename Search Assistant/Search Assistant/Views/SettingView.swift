import SwiftUI

struct SettingView: View {
    @StateObject private var settingVM = SettingViewModel()
    @ObservedObject private(set) var contentVM: ContentViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                FocusControlSection(isOn: settingVM.$settingAutoFocus)
                SearchButtonSection(isOn: settingVM.$settingLeftSearchButton)
                ColorSchemeSection(selection: settingVM.$appStorageColorScheme)
                BrowserSection(isOn: settingVM.$openInSafariView)
                KeyboardToolbarSection(
                    keyboardToolbarValisButtons: settingVM.keyboardToolbarValidButtons,
                    action: settingVM.toggleToolbarButtonAvailability
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
    SettingView(contentVM: ContentViewModel())
}
