import SwiftUI

struct SettingView: View {
    @StateObject private var settingVM = SettingViewModel()
    @ObservedObject private(set) var vm: ContentViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                FocusControlSection(isOn: settingVM.$settingAutoFocus)
                SearchButtonSection(isOn: settingVM.$settingLeftSearchButton)
                ColorSchemeSection(selection: settingVM.$appStorageColorScheme)
                BrowserSection(isOn: settingVM.$openInSafariView)
                KeyboardToolbarSection(vm: vm)
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
    SettingView(vm: ContentViewModel())
}
