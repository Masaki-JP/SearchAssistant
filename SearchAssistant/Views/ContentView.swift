import SwiftUI

struct ContentView: View {
    @FocusState var isFocused: Bool
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    @State var histories: [SearchHistory] = []
    @State var suggestions: [String] = []
    @State var isSuggestionFetchFailed = false
    @State var inputUsedToFetchCurrentSuggestions: String? = nil
    @State var userInput = ""
    @State var isPresentedSettingsView = false
    @State var isPresentedDeleteAllHistoriesAlert = false
    @State var presentedSafariViewURL: SafariViewURL? = nil
    @State var validKeyboardToolbarButtons = SearchPlatform.allCases
    
    @AppStorage(AppStorageKey.autoFocus) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButtonLeft) var settingLeftSearchButton = false
    @AppStorage(AppStorageKey.openInSafariView) var openInSafariView = true
    
    let suggestionFetcher = SuggestionFetcher.shared
    let searchURLCreator = SearchURLCreator()
    let searchHistoryRepository = SearchHistoryRepository(key: .searchHistories)
    let validKeyboardToolbarButtonRepository = ValidKeyboardToolbarButtonRepository(key: UserDefaultsKey.validKeyboardToolbarButtons)
    
    var body: some View {
        VStack(spacing: 0) {
            searchTextField
                .padding(.horizontal)
            
            Divider()
                .padding(.top, 8)
            
            Group {
                switch contentViewState {
                case .searchHistoryList:
                    historyList
                case .noSearchHistory:
                    NoContentView.searchHistory
                case .searchSuggestionList:
                    SuggestionList(suggestions: suggestions, onRowTapped: search)
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
        .background(backgroundColor, ignoresSafeAreaEdges: .all)
        .overlay(alignment: settingLeftSearchButton == false ? .bottomTrailing : .bottomLeading) {
            if isFocused == false {
                focusTextFieldButton
                    .padding(settingLeftSearchButton == false ? .trailing : .leading)
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
        .toolbar {
            ToolbarItem(placement: .keyboard, content: toolbarItemContent)
        }
        .onAppear(perform: onAppear)
        .task(id: userInput, onUserInputChange)
        .onChange(of: scenePhase, onScenePhaseChange)
        .onChange(of: isPresentedSettingsView, onIsPresentedSettingsViewChange)
        .animation(.default, value: histories)
    }
    
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

    var searchTextField: some View {
        SearchTextField(
            isFocused: $isFocused,
            userInput: $userInput,
            onSettingsButtonTapped: { isPresentedSettingsView = true },
            onInputClearButtonTapped: { userInput.removeAll() },
            onSubmit: { search(userInput, on: .google) }
        )
    }
    
    var historyList: some View {
        HistoryList(
            histories: histories,
            onRowTapped: search,
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
    
    var backgroundColor: AnyShapeStyle {
        colorScheme == .light ? AnyShapeStyle(Color(uiColor: .systemGroupedBackground)) : AnyShapeStyle(.background)
    }
    
    func toolbarItemContent() -> some View {
        let validButtons = SearchPlatform.allCases.filter(validKeyboardToolbarButtons.contains)
        
        return HStack(spacing: 4) {
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(validButtons) { searchPlatform in
                            Button(searchPlatform.displayName) {
                                search(userInput, on: searchPlatform)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .onChange(of: scenePhase) { _, newScene in
                    if newScene != .active, let scrollDestinationID = validButtons.first?.id {
                        scrollViewProxy.scrollTo(scrollDestinationID)
                    }
                }
            }
            
            Button {
                isFocused = false
            } label: {
                Image(systemName: "x.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}
