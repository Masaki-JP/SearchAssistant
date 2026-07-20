import SwiftUI
import SwiftData
import SearchCore
import SearchSuggestion

struct ContentView<EnabledSearchButtonsRepositoryType: EnabledSearchButtonsRepositoryInterface>: View {
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
    let enabledSearchButtonsRepository: EnabledSearchButtonsRepositoryType
    
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
            VStack(spacing: .zero) {
                searchTextField
                    .padding(.horizontal)
                
                Divider()
                    .padding(.top, 8)
                
                Group {
                    switch contentViewState {
                    case .searchHistoryList:
                        historyList
                            .scrollIndicators(histories.count >= 200 ? .automatic : .hidden)
                    case .noSearchHistory:
                        NoContentView.searchHistory
                    case .searchSuggestionList:
                        SuggestionList(suggestions: suggestions, onSearch: searchAction)
                            .scrollIndicators(.hidden)
                    case .noSearchSuggestion:
                        NoContentView.searchSuggestion
                    case .searchSuggestionLoading:
                        ProgressView()
                            .controlSize(.large)
                    case .searchSuggestionNetworkError:
                        NoContentView.searchSuggestionNetworkError
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.default, value: histories)
            }
            .background(backgroundColor, ignoresSafeAreaEdges: .all)
            .overlay(alignment: .bottomTrailing) {
                if isFocused == true, enabledSearchButtons.isEmpty == true {
                    keyboardCloseButton
                        .padding(.trailing)
                        .padding(.bottom, 4)
                }
            }
            .safeAreaInset(edge: .bottom) {
                if isFocused == true, enabledSearchButtons.isEmpty == false {
                    SearchButtonsBar(
                        platforms: enabledSearchButtons,
                        onSearchButtonTapped: { searchAction(userInput, on: $0) },
                        onCloseButtonTapped: { isFocused = false }
                    )
                }
            }
            .toolbar {
                if isFocused == false {
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
        }
        .fullScreenCover(item: $presentedSafariViewURL) { item in
            SafariView(url: item.url)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isPresentedSettingsView, onDismiss: onSettingsViewDismiss) {
            SettingsView(enabledSearchButtonsRepository: enabledSearchButtonsRepository)
                .preferredColorScheme(colorScheme)
        }
        .alert("確認", isPresented: $isPresentedDeleteAllHistoriesAlert) {
            Button("実行", role: .destructive) {
                removeAllHistories()
            }
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
    
    var historyList: some View {
        HistoryList(
            histories: histories,
            onSearch: searchAction,
            onDelete: removeHistory,
            isPresentedDeleteAllHistoriesAlert: $isPresentedDeleteAllHistoriesAlert
        )
    }
    
    var keyboardCloseButton: some View {
        Button("閉じる", role: .close) {
            isFocused = false
        }
        .font(.title2)
        .buttonStyle(.glass)
    }
    
    var backgroundColor: AnyShapeStyle {
        colorScheme == .light ? AnyShapeStyle(Color(uiColor: .systemGroupedBackground)) : AnyShapeStyle(.background)
    }
}

#Preview {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    ContentView(enabledSearchButtonsRepository: .fake(returnValue: returnValue))
}

#Preview(traits: .searchHistorySampleData) {
    let returnValue: [SearchPlatform] = [.amazon, .instagram, .mercari, .googleMaps]
    ContentView(enabledSearchButtonsRepository: .fake(returnValue: returnValue))
}
