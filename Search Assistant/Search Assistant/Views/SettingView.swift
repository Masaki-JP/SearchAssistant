import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = SettingViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                FocusControlSection(isOn: viewModel.$settingAutoFocus)
                SearchButtonSection(isOn: viewModel.$settingLeftSearchButton)
                ColorSchemeSection(selection: viewModel.$appStorageColorScheme)
                BrowserSection(isOn: viewModel.$openInSafariView)
                KeyboardToolbarSection(
                    validKeyboardToolbarButtons: viewModel.validKeyboardToolbarButtons,
                    action: viewModel.toggleToolbarButtonAvailability
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
