import SwiftUI
import SwiftData
import SearchCore
import SearchSuggestion

struct ContentView<BookmarkRepositoryType: BookmarkRepositoryProtocol, EnabledSearchButtonRepositoryType: EnabledSearchButtonRepositoryProtocol>: View {
    @FocusState var isFocused: Bool
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \SearchHistory.date, order: .reverse, animation: .default)
    var histories: [SearchHistory]
    @State var suggestions: [String] = []
    @State var isSuggestionFetchFailed = false
    @State var inputUsedToFetchCurrentSuggestions: String? = nil
    @State var userInput = ""
    @State var presentedSettings: SettingsPresentation? = nil
    @State var isPresentedDeleteAllHistoriesAlert = false
    @State var presentedSafariViewURL: SafariViewURL? = nil
    @State var bookmarks: [Bookmark] = []
    @State var enabledSearchButtons = SearchPlatform.allCases
    
    @AppStorage(UserDefaultsKey.AppStorageKey.autoFocus.rawValue)
    var isSearchFieldAutoFocusEnabled = UserDefaultsKey.AppStorageDefaultValue.autoFocus
    @AppStorage(UserDefaultsKey.AppStorageKey.openInSafariView.rawValue)
    var openInSafariView = UserDefaultsKey.AppStorageDefaultValue.openInSafariView
    
    let suggestionFetcher = SuggestionFetcher.shared
    let searchURLCreator = SearchURLCreator()
    let bookmarkRepository: BookmarkRepositoryType
    let enabledSearchButtonRepository: EnabledSearchButtonRepositoryType
    
    /// historiesが日付の降順で並んでいることを前提に、履歴を日付でグループ化する。
    var historiesGroupedByDay: [(date: Date, histories: [SearchHistory])] {
        let calendar = Calendar.current
        
        return histories.reduce(into: []) { groups, history in
            let date = calendar.startOfDay(for: history.date)
            
            if let lastIndex = groups.indices.last, groups[lastIndex].date == date {
                groups[lastIndex].histories.append(history)
            } else {
                groups.append((date: date, histories: [history]))
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if userInput.isEmpty == true {
                    if histories.isEmpty == false {
                        historySections
                            .scrollIndicators(histories.count >= 200 ? .visible : .hidden)
                    }
                } else {
                    if isSuggestionFetchFailed == false, suggestions.isEmpty == false {
                        suggestionSection
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .overlay {
                if userInput.isEmpty == true {
                    if histories.isEmpty == true {
                        NoContentView.searchHistory
                    }
                } else {
                    if isSuggestionFetchFailed == false {
                        if suggestions.isEmpty == true {
                            if inputUsedToFetchCurrentSuggestions == userInput {
                                NoContentView.searchSuggestion
                            } else {
                                ProgressView().controlSize(.large)
                            }
                        }
                    } else {
                        NoContentView.searchSuggestionNetworkError
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if isFocused == true, enabledSearchButtons.isEmpty == true {
                    keyboardCloseButton
                        .padding(.trailing)
                        .padding(.bottom, 4)
                }
            }
            .safeAreaInset(edge: .top) { // ※1
                VStack(spacing: 8) {
                    searchTextField
                        .padding(.horizontal)
                    
                    Divider()
                }
                .background(Color(uiColor: .systemGroupedBackground).opacity(0.8))
            }
            .safeAreaInset(edge: .bottom) {
                if isFocused == true, enabledSearchButtons.isEmpty == false {
                    searchButtonsBar
                }
            }
            .toolbar {
                if isFocused == false {
                    bottomToolbarContent
                }
            }
            .scrollEdgeEffectHidden()
        }
        .fullScreenCover(item: $presentedSafariViewURL) { item in
            SafariView(url: item.url)
                .ignoresSafeArea()
        }
        .sheet(item: $presentedSettings, onDismiss: onSettingsViewDismiss) { presentation in
            let path: [SettingsRoute] = switch presentation {
            case .root: .init()
            case .editBookmarks: [.bookmarkList]
            case .newBookmark: [.bookmarkList, .bookmarkForm(nil)]
            }
            
            SettingsView(
                path: path,
                bookmarkRepository: bookmarkRepository,
                enabledSearchButtonRepository: enabledSearchButtonRepository
            )
            .presentationDragIndicator(.visible)
            .preferredColorScheme(colorScheme)
        }
        .alert("確認", isPresented: $isPresentedDeleteAllHistoriesAlert) {
            Button("実行", role: .destructive) { removeAllHistories() }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("全履歴を削除しますか？")
        }
        .onAppear(perform: onAppear)
        .task(id: userInput, onUserInputChange)
        .onChange(of: scenePhase, initial: true, onScenePhaseChange)
        .onChange(of: presentedSettings, onPresentedSettingsChange)
    }
    
    var searchTextField: some View {
        SearchTextField(
            isFocused: $isFocused,
            userInput: $userInput,
            onSettingsButtonTapped: { presentedSettings = .root },
            onInputClearButtonTapped: { userInput.removeAll() },
            onSubmit: { searchAction(userInput, on: .google) }
        )
    }
    
    var historySections: some View {
        let historyGroups = historiesGroupedByDay
        let onDeleteAllHistories = { isPresentedDeleteAllHistoriesAlert = true }
        
        return ForEach(historyGroups, id: \.date) { group in
            HistorySection(
                histories: group.histories,
                isBookmarked: isBookmarked,
                onSearch: searchAction,
                onBookmarkToggled: toggleBookmark,
                onDelete: removeHistories,
                onDeleteAllHistories: group.date == historyGroups.last?.date ? onDeleteAllHistories : nil
            )
        }
    }
    
    var suggestionSection: some View {
        SuggestionSection(
            suggestions: suggestions,
            onSearch: searchAction
        )
    }
    
    var searchButtonsBar: some View {
        SearchButtonsBar(
            platforms: enabledSearchButtons,
            onSearchButtonTapped: { searchAction(userInput, on: $0) },
            onCloseButtonTapped: { isFocused = false }
        )
    }
    
    var keyboardCloseButton: some View {
        Button("閉じる", role: .close) {
            isFocused = false
        }
        .font(.title2)
        .buttonStyle(.glass)
    }
    
    @ToolbarContentBuilder
    var bottomToolbarContent: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Menu("ブックマーク一覧", systemImage: "bookmark") {
                Section {
                    ForEach(bookmarks) { bookmark in
                        Button {
                            searchAction(bookmark.userInput, on: bookmark.platform)
                        } label: {
                            Text(bookmark.userInput)
                            Text("（\(bookmark.platform.shortDisplayName)）")
                        }
                    }
                } header: {
                    Text("ブックマーク")
                }
                
                Divider()
                
                ControlGroup {
                    Button("編集", systemImage: "list.bullet") { presentedSettings = .editBookmarks }
                    Button("登録", systemImage: "plus.rectangle") { presentedSettings = .newBookmark }
                }
            }
            .menuOrder(.fixed)
        }
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            Button("検索", systemImage: "magnifyingglass") {
                isFocused = true
            }
        }
    }
}

/*
 ※1: safeAreaBarを使用すると、キーボードは表示されるがFocusStateの値が変更されないため、safeAreaInsetを使用する。
 */

#Preview("Light 1", traits: .searchHistorySampleData) {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    
    ContentView(
        bookmarkRepository: .fake(returnValue: Bookmark.samples),
        enabledSearchButtonRepository: .fake(returnValue: returnValue)
    )
    .preferredColorScheme(.light)
}

#Preview("Light 2") {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    
    ContentView(
        bookmarkRepository: .fake(returnValue: Bookmark.samples),
        enabledSearchButtonRepository: .fake(returnValue: returnValue)
    )
    .preferredColorScheme(.light)
}

#Preview("Light 3", traits: .searchHistorySampleData) {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    
    ContentView(
        userInput: "apple",
        bookmarkRepository: .fake(returnValue: Bookmark.samples),
        enabledSearchButtonRepository: .fake(returnValue: returnValue)
    )
    .preferredColorScheme(.light)
}

#Preview("Dark 1", traits: .searchHistorySampleData) {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    
    ContentView(
        bookmarkRepository: .fake(returnValue: Bookmark.samples),
        enabledSearchButtonRepository: .fake(returnValue: returnValue)
    )
    .preferredColorScheme(.dark)
}

#Preview("Dark 2") {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    
    ContentView(
        bookmarkRepository: .fake(returnValue: Bookmark.samples),
        enabledSearchButtonRepository: .fake(returnValue: returnValue)
    )
    .preferredColorScheme(.dark)
}

#Preview("Dark 3", traits: .searchHistorySampleData) {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    
    ContentView(
        userInput: "apple",
        bookmarkRepository: .fake(returnValue: Bookmark.samples),
        enabledSearchButtonRepository: .fake(returnValue: returnValue)
    )
    .preferredColorScheme(.dark)
}
