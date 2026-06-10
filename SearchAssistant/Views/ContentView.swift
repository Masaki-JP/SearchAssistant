import SwiftUI

struct ContentView: View {
    @FocusState var isFocused: Bool
    @Environment(\.scenePhase) var scenePhase
    
    @State var historys: [SearchHistory] = []
    @State var suggestions: [String]? = []
    @State var userInput = ""
    @State var isPresentedSettingsView = false
    @State var isPresentedDeleteAllHistoriesAlert = false
    @State var presentedSafariViewURL: SafariViewURL? = nil
    @State var validKeyboardToolbarButtons = Set(SearchPlatform.allCases)
    
    @AppStorage(AppStorageKey.autoFocus) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButton_Left) var settingLeftSearchButton = false
    @AppStorage("openInSafariView") var openInSafariView = true
    
    let suggestionFetcher = SuggestionFetcher.shared
    let searchURLCreater = SearchURLCreater()
    let searchHistoryRepository = UserDefaultsRepository<[SearchHistory]>(key: .searchHistorys)
    let validKeyboardToolbarButtonRepository = UserDefaultsRepository<Set<SearchPlatform>>(key: UserDefaultsKey.validKeyboardToolbarButtons)
    
    var body: some View {
        VStack(spacing: 0) {
            SearchTextField(
                isFocused: $isFocused,
                userInput: $userInput,
                onSettingsButtonTapped: { isPresentedSettingsView = true },
                onInputClearButtonTapped: { userInput.removeAll() },
                onSubmit: { search(userInput, on: .google) }
            )
            .padding(.horizontal)
            Divider()
                .padding(.top, 5)
            if userInput.isEmpty {
                if historys.isEmpty == false {
                    HistoryList(
                        historys: historys,
                        searchAction: search(_:on:),
                        removeHistoryAction: removeHistory(atOffsets:),
                        isPresentedDeleteAllHistoriesAlert: $isPresentedDeleteAllHistoriesAlert
                    )
                } else {
                    NoContentView.searchHistory
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                if let suggestions {
                    if suggestions.isEmpty == false {
                        SuggestionList(
                            suggestions: suggestions,
                            action: search(_:on:)
                        )
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
        .onAppear {
            do {
                historys = try searchHistoryRepository.fetch()
            } catch {
                reportError(error)
            }
            
            fetchValidKeyboardToolbarButtons()
            
            guard settingAutoFocus == true,
                  isPresentedSettingsView == false,
                  isPresentedDeleteAllHistoriesAlert == false
            else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                isFocused = true
            }
        }
        .onChange(of: scenePhase) { _, newScene in
            guard newScene == .active,
                  settingAutoFocus == true,
                  isPresentedSettingsView == false,
                  isPresentedDeleteAllHistoriesAlert == false,
                  presentedSafariViewURL == nil
            else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                isFocused = true
            }
        }
        .onChange(of: isPresentedSettingsView) { _, newScene in
            if newScene == true { isFocused = false }
        }
        .onChange(of: userInput) {
            guard userInput.isEmpty == false else { return }
            Task { await getSuggestion(from: userInput) }
        }
        .fullScreenCover(item: $presentedSafariViewURL) { item in
            SafariView(url: item.url)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isPresentedSettingsView) {
            fetchValidKeyboardToolbarButtons()
            guard settingAutoFocus else { return }
            isFocused = true
        } content: {
            SettingsView()
        }
        .alert("確認", isPresented: $isPresentedDeleteAllHistoriesAlert) {
            Button("実行", role: .destructive) {
                removeAllHistorys()
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("全履歴を削除しますか？")
        }
        .toolbar {
            ToolbarItem(placement: .keyboard, content: toolbarItemContent)
        }
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
