import SwiftUI

struct SettingView: View {
    @ObservedObject private(set) var vm: ContentViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                FocusControlSection(isOn: vm.$settingAutoFocus)
                SearchButtonSection(isOn: vm.$settingLeftSearchButton)
                ColorSchemeSection(selection: vm.$appStorageColorScheme)
                BrowserSection(isOn: vm.$openInSafariView)
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
