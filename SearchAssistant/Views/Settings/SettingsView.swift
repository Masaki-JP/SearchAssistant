import SwiftUI
import SwiftData
import SearchCore

struct SettingsView<BookmarkRepositoryType: BookmarkRepositoryProtocol, EnabledSearchButtonRepositoryType: EnabledSearchButtonRepositoryProtocol>: View {
    @State var enabledSearchButtons = SearchPlatform.allCases
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @AppStorage(UserDefaultsKey.AppStorageKey.autoFocus.rawValue)
    var settingAutoFocus = UserDefaultsKey.AppStorageDefaultValue.autoFocus
    @AppStorage(UserDefaultsKey.AppStorageKey.colorScheme.rawValue)
    var colorSchemeSetting = ColorSchemeSetting.defaultValue
    @AppStorage(UserDefaultsKey.AppStorageKey.openInSafariView.rawValue)
    var openInSafariView = UserDefaultsKey.AppStorageDefaultValue.openInSafariView
    @AppStorage(UserDefaultsKey.AppStorageKey.historyMaximumCount.rawValue)
    var historyMaximumCount = SearchHistory.defaultMaximumCount
    
    let selectionSoundPlayer = SelectionSoundPlayer()
    let bookmarkRepository: BookmarkRepositoryType
    let enabledSearchButtonRepository: EnabledSearchButtonRepositoryType
    
    var body: some View {
        NavigationStack {
            Form {
                focusControlSection
                colorSchemeSection
                browserSection
                searchButtonsBarSection
                bookmarkSection
                historySection
                appInfoSection
            }
            .scrollIndicators(.hidden)
            .navigationTitle("各種設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完了", action: dismiss.callAsFunction)
                }
            }
        }
        .onAppear(perform: loadEnabledSearchButtons)
        .onChange(of: historyMaximumCount, trimHistoriesIfNeeded)
        .onChange(of: scenePhase) { _, newScene in
            guard newScene != .active else { return }
            dismiss()
        }
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
            Text("アプリが表示された時に、検索フォームに自動でフォーカスします。（設定が開かれている場合などは除く）")
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
            onSearchButtonsBarOrderSaved: onSearchButtonsBarOrderSaved
        )
    }
    
    var bookmarkSection: some View {
        Section {
            NavigationLink("ブックマークを編集") {
                BookmarkListView(bookmarkRepository: bookmarkRepository)
            }
        } header: {
            Text("ブックマーク")
        }
    }
    
    var historySection: some View {
        Section {
            Picker("保存件数", selection: $historyMaximumCount) {
                ForEach(SearchHistory.maximumCountOptions, id: \.self) { maximumCount in
                    Text("\(maximumCount.formatted())件")
                        .tag(maximumCount)
                }
            }
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
}

#Preview {
    @Previewable @State var isPresented = true
    let returnValue: [SearchPlatform] = [.youtube, .amazon, .mercari, .googleMaps]
    
    Button("Show SettingsView") {
        isPresented = true
    }
    .sheet(isPresented: $isPresented) {
        SettingsView(
            bookmarkRepository: .fake(returnValue: Bookmark.samples),
            enabledSearchButtonRepository: .fake(returnValue: returnValue)
        )
    }
}
