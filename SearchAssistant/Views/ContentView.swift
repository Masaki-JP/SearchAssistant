import SwiftUI

struct ContentView: View {
    @FocusState var isFocused: Bool
    @Environment(\.scenePhase) var scenePhase
    
    @State var historys: [SearchHistory] = []
    let searchHistoryRepository = UserDefaultsRepository<[SearchHistory]>(key: .searchHistorys)
    @State var suggestions: [String]? = []
    let suggestionFetcher = SuggestionFetcher.shared
    
    struct SafariViewURL: Identifiable {
        let url: URL; let id = UUID();
    }
    
    let searchURLCreater = SearchURLCreater()
    
    @State var isPresentedSettingsView = false
    @State var isShowPromptToConfirmDeletionOFAllHistorys = false
    @State var safariViewURL: SafariViewURL? = nil
    
    @AppStorage(AppStorageKey.autoFocus) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButton_Left) var settingLeftSearchButton = false
    @AppStorage("openInSafariView") var openInSafariView = true
    
    @State var validKeyboardToolbarButtons = Set(SearchPlatform.allCases)
    let validKeyboardToolbarButtonRepository = UserDefaultsRepository<Set<SearchPlatform>>(key: UserDefaultsKey.validKeyboardToolbarButtons)
    
    @State var userInput = ""
    
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
                        isShowPromptToConfirmDeletionOfAllHistorys: $isShowPromptToConfirmDeletionOFAllHistorys
                    )
                } else {
                    NoContentView(
                        title: "I am Search Assistant !",
                        description: "Google, Twitter(X), Instagram, Amazon,  YouTubeなどの\n検索をこのアプリひとつで行うことができます。",
                        imageSystemName: "doc.text.magnifyingglass"
                    )
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
                        NoContentView(
                            title: "候補が見つかりません",
                            description: "入力したキーワードでそのまま検索できます。",
                            imageSystemName: "magnifyingglass"
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    NoContentView(
                        title: "Sorry! Network Error!",
                        description: "入力内容に基づく検索候補の取得に失敗しました。モバイル通信、Wi-Fi、機内モードなどの設定をご確認ください。",
                        imageSystemName: "network.slash"
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .overlay(alignment: settingLeftSearchButton == false ? .bottomTrailing : .bottomLeading) {
            if isFocused == false {
                FocusTextFieldButton { isFocused = true }
                    .padding(
                        settingLeftSearchButton == false ?
                            .trailing : .leading
                    )
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
                  isShowPromptToConfirmDeletionOFAllHistorys == false
            else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                isFocused = true
            }
        }
        .onChange(of: scenePhase) { _, newScene in
            guard newScene == .active,
                  settingAutoFocus == true,
                  isPresentedSettingsView == false,
                  isShowPromptToConfirmDeletionOFAllHistorys == false,
                  safariViewURL == nil
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
        .fullScreenCover(item: $safariViewURL) { item in
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
        .alert("確認", isPresented: $isShowPromptToConfirmDeletionOFAllHistorys) {
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
