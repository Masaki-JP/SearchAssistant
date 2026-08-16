import SwiftUI
import SwiftData
import SearchCore

struct SettingsView<BookmarkRepositoryType: BookmarkRepositoryProtocol, EnabledSearchButtonRepositoryType: EnabledSearchButtonRepositoryProtocol>: View {
    @State var path: [SettingsRoute]
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
    
    init(
        path: [SettingsRoute] = .init(),
        bookmarkRepository: BookmarkRepositoryType,
        enabledSearchButtonRepository: EnabledSearchButtonRepositoryType
    ) {
        self.path = path
        self.bookmarkRepository = bookmarkRepository
        self.enabledSearchButtonRepository = enabledSearchButtonRepository
    }
    
    let selectionSoundPlayer = SelectionSoundPlayer()
    let bookmarkRepository: BookmarkRepositoryType
    let enabledSearchButtonRepository: EnabledSearchButtonRepositoryType
    
    var body: some View {
        NavigationStack(path: $path) {
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
            .inlineNavigationTitle("各種設定")
            .navigationDestination(for: SettingsRoute.self) { route in
                switch route {
                case .searchButtonsBar:
                    SearchButtonsBarView(
                        enabledSearchButtons: enabledSearchButtons,
                        onPlatformButtonTapped: toggleSearchButtonEnabled
                    )
                    .inlineNavigationTitle("サーチボタンバー")
                    
                case .searchButtonsBarOrder:
                    ReorderableListView(
                        defaultValue: enabledSearchButtons,
                        onSave: onSearchButtonsBarOrderSaved
                    ) { platform in
                        Text(platform.displayName)
                    } sectionHeader: {
                        Text("サーチボタンバー")
                    } sectionFooter: {
                        Text("サーチボタンバーに表示する検索ボタンの並び順を設定できます。")
                    }
                    .inlineNavigationTitle("表示順序")
                    
                case .bookmarkList:
                    BookmarkListView(
                        bookmarkRepository: bookmarkRepository
                    )
                    .inlineNavigationTitle("ブックマーク")
                    
                case .bookmarkForm(let defaultValue):
                    BookmarkFormView(defaultValue: defaultValue) { userInput, platform in
                        if let defaultValue {
                            let updatedBookmark = Bookmark(id: defaultValue.id, userInput: userInput, platform: platform)
                            try bookmarkRepository.update(updatedBookmark)
                        } else {
                            try bookmarkRepository.add(.init(userInput: userInput, platform: platform))
                        }
                    }
                    .inlineNavigationTitle(defaultValue == nil ? "ブックマークを登録" : "ブックマークを編集")
                    
                case .bookmarkOrder(let bookmarks):
                    ReorderableListView(defaultValue: bookmarks, onSave: bookmarkRepository.save) { bookmark in
                        HStack(spacing: nil) {
                            FaviconImage(platform: bookmark.platform)
                            
                            Text(bookmark.userInput)
                                .lineLimit(1)
                                .padding(.leading, 4)
                        }
                    } sectionHeader: {
                        Text("登録済みブックマーク")
                    }
                    .inlineNavigationTitle("表示順序")
                }
            }
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
        Section {
            NavigationLink("サーチボタンバーを編集", value: SettingsRoute.searchButtonsBar)
        } header: {
            Text("サーチボタンバー")
        }
    }
    
    var bookmarkSection: some View {
        Section {
            NavigationLink("ブックマークを編集", value: SettingsRoute.bookmarkList)
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
