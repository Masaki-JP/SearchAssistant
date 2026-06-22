import SwiftUI
import SwiftData
import SearchCore
import SearchSuggestion

struct ContentView: View {
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
    @AppStorage(UserDefaultsKey.AppStorageKey.searchButtonLeft.rawValue) var settingLeftSearchButton = false
    @AppStorage(UserDefaultsKey.AppStorageKey.openInSafariView.rawValue) var openInSafariView = true
    
    let suggestionFetcher = SuggestionFetcher.shared
    let searchURLCreator = SearchURLCreator()
    let enabledSearchButtonsRepository = EnabledSearchButtonsRepository()
    
    /// ContentView に表示するコンテンツの状態を返す。
    ///
    /// - 入力なし
    ///   - 履歴あり：検索履歴一覧を表示する。
    ///   - 履歴なし：検索履歴がないことを表示する。
    /// - 入力あり
    ///   - 候補の取得に失敗：ネットワークエラーを表示する。
    ///   - 候補あり：検索候補一覧を表示する。
    ///   - 候補なし：検索候補がないことを表示する。
    ///   - その他：検索候補の取得中として表示する。
    ///
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
        
        // MARK: - Main Content
        
        VStack(spacing: 0) {
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
                    SuggestionList(suggestions: suggestions, onRowTapped: searchAction)
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
        }
        
        // MARK: - Style Modifier
        
        .background(backgroundColor, ignoresSafeAreaEdges: .all)
        .overlay(alignment: settingLeftSearchButton == false ? .bottomTrailing : .bottomLeading) {
            if isFocused == false {
                GeometryReader { geometryProxy in
                    focusTextFieldButton
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: settingLeftSearchButton == false ? .bottomTrailing : .bottomLeading
                        )
                        .padding(
                            settingLeftSearchButton == false ? .trailing : .leading,
                            leadingOrTrailingPadding(geometryProxy)
                        )
                        .padding(.bottom, bottomPadding(geometryProxy))
                }
            } else {
                if enabledSearchButtons.isEmpty == true {
                    keyboardCloseButton
                        .padding(settingLeftSearchButton == false ? .trailing : .leading)
                        .padding(.bottom, 4)
                }
            }
        }
        .overlay(alignment: .bottom) {
            if isFocused == true, enabledSearchButtons.isEmpty == false {
                SearchButtonsBar(
                    platforms: enabledSearchButtons,
                    onSearchButtonTapped: { searchAction(userInput, on: $0) },
                    onCloseButtonTapped: { isFocused = false }
                )
            }
        }
        .fullScreenCover(item: $presentedSafariViewURL) { item in
            SafariView(url: item.url)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isPresentedSettingsView, onDismiss: onSettingsViewDismiss, content: {
            SettingsView()
                .preferredColorScheme(colorScheme)
        })
        .alert("確認", isPresented: $isPresentedDeleteAllHistoriesAlert) {
            Button("実行", role: .destructive) {
                removeAllHistories()
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("全履歴を削除しますか？")
        }
        
        // MARK: - Behavior Modifier
        
        .onAppear(perform: onAppear)
        .task(id: userInput, onUserInputChange)
        .onChange(of: scenePhase, onScenePhaseChange)
        .onChange(of: isPresentedSettingsView, onIsPresentedSettingsViewChange)
        .animation(.default, value: histories)
    }
    
    // MARK: - View Components
    
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
            onRowTapped: searchAction,
            onDelete: removeHistory,
            isPresentedDeleteAllHistoriesAlert: $isPresentedDeleteAllHistoriesAlert
        )
    }
    
    var focusTextFieldButton: some View {
        Button {
            isFocused = true
        } label: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .padding(10)
                .frame(width: 45, height: 45)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
    }
    
    var keyboardCloseButton: some View {
        Button("Close", role: .close) {
            isFocused = false
        }
        .font(.title2)
        .buttonStyle(.glass)
    }
    
    // MARK: - Style Values

    var backgroundColor: AnyShapeStyle {
        colorScheme == .light ? AnyShapeStyle(Color(uiColor: .systemGroupedBackground)) : AnyShapeStyle(.background)
    }
    
    func leadingOrTrailingPadding(_ geometryProxy: GeometryProxy) -> CGFloat {
        geometryProxy.safeAreaInsets.bottom != .zero ? geometryProxy.safeAreaInsets.bottom - 10 : 10
    }
    
    func bottomPadding(_ geometryProxy: GeometryProxy) -> CGFloat {
        geometryProxy.safeAreaInsets.bottom != .zero ? -10 : 10
    }
}

#Preview {
    ContentView()
}
