import SwiftUI

struct ContentView: View {
    @FocusState var isFocused: Bool
    @Environment(\.scenePhase) var scenePhase
    
    @State var histories: [SearchHistory] = []
    @State var suggestions: [String] = []
    @State var isSuggestionFetchFailed = false
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
                .padding(.top, 5)
            
            if userInput.isEmpty == true {
                if histories.isEmpty == false {
                    historyList
                } else {
                    NoContentView.searchHistory
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                if isSuggestionFetchFailed == false {
                    if suggestions.isEmpty == false {
                        SuggestionList(suggestions: suggestions, onRowTapped: search)
                    } else {
                        NoContentView.searchSuggestion
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    NoContentView.searchSuggestionNetworkError
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
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
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .background(.white)
                .clipShape(Circle().scale(0.95))
        }
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
