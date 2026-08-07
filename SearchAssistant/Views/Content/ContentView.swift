import SwiftUI
import SwiftData
import SearchCore
import SearchSuggestion

struct ContentView<EnabledSearchButtonRepositoryType: EnabledSearchButtonRepositoryInterface>: View {
    @FocusState var isFocused: Bool
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \SearchHistory.date, order: .reverse) var histories: [SearchHistory]
    @State var suggestions: [String] = []
    @State var isSuggestionFetchFailed = false
    @State var inputUsedToFetchCurrentSuggestions: String? = nil
    @State var userInput = ""
    @State var isPresentedSettingsView = false
    @State var isPresentedDeleteAllHistoriesAlert = false
    @State var presentedSafariViewURL: SafariViewURL? = nil
    @State var enabledSearchButtons = SearchPlatform.allCases
    
    @AppStorage(UserDefaultsKey.AppStorageKey.autoFocus.rawValue) var settingAutoFocus = true
    @AppStorage(UserDefaultsKey.AppStorageKey.openInSafariView.rawValue) var openInSafariView = false
    
    let suggestionFetcher = SuggestionFetcher.shared
    let searchURLCreator = SearchURLCreator()
    let enabledSearchButtonRepository: EnabledSearchButtonRepositoryType
    
    var contentViewState: ContentViewState {
        if userInput.isEmpty == true {
            if histories.isEmpty == false {
                .searchHistoryList
            } else {
                .noSearchHistory
            }
        } else {
            if isSuggestionFetchFailed == false {
                if suggestions.isEmpty == false {
                    .searchSuggestionList
                } else if inputUsedToFetchCurrentSuggestions == userInput {
                    .noSearchSuggestion
                } else {
                    .searchSuggestionLoading
                }
            } else {
                .searchSuggestionNetworkError
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if userInput.isEmpty == true {
                    if histories.isEmpty == false {
                        historySection
                            .scrollIndicators(histories.count >= 200 ? .visible : .hidden)
                    }
                } else {
                    if isSuggestionFetchFailed == false, suggestions.isEmpty == false {
                        suggestionSection
                    }
                }
            }
            .scrollIndicators(.hidden)
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
            .safeAreaInset(edge: .top) {
                VStack(spacing: 8) {
                    searchTextField
                        .padding(.horizontal)
                    
                    Divider()
                }
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
        .sheet(isPresented: $isPresentedSettingsView, onDismiss: onSettingsViewDismiss) {
            SettingsView(enabledSearchButtonRepository: enabledSearchButtonRepository)
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
        .onChange(of: scenePhase, onScenePhaseChange)
        .onChange(of: isPresentedSettingsView, onIsPresentedSettingsViewChange)
    }
    
    var searchTextField: some View {
        SearchTextField(
            isFocused: $isFocused,
            userInput: $userInput,
            onSettingsButtonTapped: { isPresentedSettingsView = true },
            onInputClearButtonTapped: { userInput.removeAll() },
            onSubmit: { searchAction(userInput, on: .google) }
        )
    }
    
    var historySection: some View {
        HistorySection(
            histories: histories,
            onSearch: searchAction,
            onDelete: removeHistory,
            isPresentedDeleteAllHistoriesAlert: $isPresentedDeleteAllHistoriesAlert
        )
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
        ToolbarSpacer(placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            Button("検索", systemImage: "magnifyingglass") {
                isFocused = true
            }
            .buttonStyle(.glassProminent)
            .labelStyle(.iconOnly)
        }
    }
}

#Preview("Light 1") {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    ContentView(enabledSearchButtonRepository: .fake(returnValue: returnValue))
        .preferredColorScheme(.light)
}

#Preview("Light 2", traits: .searchHistorySampleData) {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    ContentView(enabledSearchButtonRepository: .fake(returnValue: returnValue))
        .preferredColorScheme(.light)
}

#Preview("Dark 1") {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    ContentView(enabledSearchButtonRepository: .fake(returnValue: returnValue))
        .preferredColorScheme(.dark)
}

#Preview("Dark 2", traits: .searchHistorySampleData) {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    ContentView(enabledSearchButtonRepository: .fake(returnValue: returnValue))
        .preferredColorScheme(.dark)
}
