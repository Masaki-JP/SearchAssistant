import SwiftUI
import SearchCore

struct SettingsView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    
    @AppStorage(UserDefaultsKey.AppStorageKey.autoFocus.rawValue) var settingAutoFocus = true
    @AppStorage(UserDefaultsKey.AppStorageKey.searchButtonLeft.rawValue) var settingLeftSearchButton = false
    @AppStorage(UserDefaultsKey.AppStorageKey.colorScheme.rawValue) var colorSchemeSetting = ColorSchemeSetting.defaultValue
    @AppStorage(UserDefaultsKey.AppStorageKey.openInSafariView.rawValue) var openInSafariView = true
    
    @State var enabledSearchButtons = SearchPlatform.allCases
    @State var isPresentedSearchButtonsBarOrderView = false
    let selectionSoundPlayer = SelectionSoundPlayer()
    let enabledSearchButtonsRepository = EnabledSearchButtonsRepository()
    
    var body: some View {
        NavigationStack {
            Form {
                focusControlSection
                searchButtonPositionSection
                colorSchemeSection
                browserSection
                searchButtonsBarSection
                historySection
                appInfoSection
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isPresentedSearchButtonsBarOrderView, destination: {
                searchButtonsBarOrderView
                    .navigationTitle("表示順序")
            })
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
        .onAppear(perform: loadEnabledSearchButtons)
        .sensoryFeedback(.selection, trigger: enabledSearchButtons)
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
            Picker("外観モード", selection: $colorSchemeSetting) {
                ForEach(ColorSchemeSetting.allCases) { colorSchemeSetting in
                    Text(colorSchemeSetting.label)
                        .tag(colorSchemeSetting)
                }
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
    
    var searchButtonsBarSection: some View {
        SearchButtonsBarSection(
            enabledSearchButtons: enabledSearchButtons,
            onPlatformButtonTapped: toggleSearchButtonEnabled,
            onSearchButtonsBarOrderButtonTapped: { isPresentedSearchButtonsBarOrderView = true }
        )
    }
    
    var historySection: some View {
        Section {
            LabeledContent("保存件数", value: "最大\(SearchHistory.maximumCount.formatted())件(固定)")
        } header: {
            Text("履歴")
        } footer: {
            Text("上限を超えた場合は、古い履歴から自動で削除されます。")
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
    
    var searchButtonsBarOrderView: some View {
        List {
            Section {
                ForEach(enabledSearchButtons) { platform in
                    Text(platform.displayName)
                }
                .onMove(perform: onSearchButtonsMove)
            } header: {
                Text("サーチボタンバー")
            } footer: {
                Text("サーチボタンバーに表示する検索ボタンの並び順を設定できます。")
            }
        }
        .environment(\.editMode, .constant(.active))
    }
}

#Preview {
    SettingsView()
}
