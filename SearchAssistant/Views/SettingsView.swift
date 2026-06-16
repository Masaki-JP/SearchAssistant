import SwiftUI

struct SettingsView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    
    @AppStorage(AppStorageKey.autoFocus) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButtonLeft) var settingLeftSearchButton = false
    @AppStorage(AppStorageKey.colorScheme) var appStorageColorScheme = ColorSchemeSetting.dark.rawValue
    @AppStorage(AppStorageKey.openInSafariView) var openInSafariView = true
    
    @State var validKeyboardToolbarButtons = SearchPlatform.allCases
    let validKeyboardToolbarButtonRepository = ValidKeyboardToolbarButtonRepository()
    
    var body: some View {
        NavigationStack {
            Form {
                focusControlSection
                searchButtonPositionSection
                colorSchemeSection
                browserSection
                KeyboardToolbarSection(validKeyboardToolbarButtons: validKeyboardToolbarButtons, action: toggleToolbarButtonAvailability)
                appInfoSection
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
        .onAppear(perform: loadValidKeyboardToolbarButtons)
        .sensoryFeedback(.selection, trigger: validKeyboardToolbarButtons)
    }
    
    var focusControlSection: some View {
        Section {
            Toggle(isOn: $settingAutoFocus) {
                Text("キーボードの自動表示")
            }
        } header: {
            Text("キーボード")
        } footer: {
            Text("検索画面が表示された時に、検索フォームに自動でフォーカスします。")
        }
    }
    
    var searchButtonPositionSection: some View {
        Section {
            Toggle(isOn: $settingLeftSearchButton) {
                Text("左利き用の配置")
            }
        } header: {
            Text("検索ボタン")
        } footer: {
            Text("検索ボタンを画面左下に配置します。")
        }
    }
    
    var colorSchemeSection: some View {
        Section {
            Picker("外観モード", selection: $appStorageColorScheme) {
                Text("ライト")
                    .tag(ColorSchemeSetting.light.rawValue)
                Text("ダーク")
                    .tag(ColorSchemeSetting.dark.rawValue)
                Text("システム")
                    .tag(ColorSchemeSetting.system.rawValue)
            }
        } header: {
            Text("外観モード")
        } footer: {
            Text("iPhoneの外観モードに合わせるにはシステムを選択してください。")
        }
        
    }
    
    var browserSection: some View {
        Section {
            Toggle("アプリ内ブラウザで開く", isOn: $openInSafariView)
        } header: {
            Text("ブラウザ")
        } footer: {
            Text("上記の設定をオフにした場合、検索はSafariで行われます。")
        }
    }
    
    var appInfoSection: some View {
        Section {
            LabeledContent("バージョン", value: bundleShortVersionString)
            LabeledContent("ビルド", value: bundleVersion)
        } header: {
            Text("アプリ情報")
        }
    }
    
    var bundleShortVersionString: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    }
    
    var bundleVersion: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
    }
}

#Preview {
    SettingsView()
}
