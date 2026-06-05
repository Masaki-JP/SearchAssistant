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

    @State var isPresentedSettingView = false
    @State var isShowInstagramErrorAlert = false
    @State var isShowPromptToConfirmDeletionOFAllHistorys = false
    @State var safariViewURL: SafariViewURL? = nil

    @AppStorage(AppStorageKey.autoFocus) var settingAutoFocus = true
    @AppStorage(AppStorageKey.searchButton_Left) var settingLeftSearchButton = false
    @AppStorage("openInSafariView") var openInSafariView = true

    @State var validKeyboardToolbarButtons = Set(SearchPlatform.allCases)
    let validKeyboardToolbarButtonRepository = UserDefaultsRepository<Set<SearchPlatform>>(key: UserDefaultsKey.validKeyboardToolbarButtons)

    @State var userInput = ""

    init() {
        do {
            historys = try searchHistoryRepository.fetch()
        } catch {
            reportError(error)
        }

        fetchValidKeyboardToolbarButtons()
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchTextField(
                isFocused: $isFocused,
                userInput: $userInput,
                onSettingsButtonTapped: { isPresentedSettingView = true },
                onInputClearButtonTapped: { userInput.removeAll() },
                onSubmit: { search(userInput, on: .google) }
            )
            .padding(.horizontal)
            Divider()
                .padding(.top, 5)
            if userInput.isEmpty {
                HistoryList(
                    historys: historys,
                    searchAction: search(_:on:),
                    removeHistoryAction: removeHistory(atOffsets:),
                    isShowPromptToConfirmDeletionOfAllHistorys: $isShowPromptToConfirmDeletionOFAllHistorys
                )
            } else {
                SuggestionList(
                    suggestions: suggestions,
                    action: search(_:on:)
                )
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
        .modifier(
            ImplementationButtonsOnKeyboardToolbar(
                isFocused: $isFocused.projectedValue,
                platforms: SearchPlatform.allCases.filter(validKeyboardToolbarButtons.contains),
                onButtonTapped: { serchPlatform in
                    search(userInput, on: serchPlatform)
                },
                onScenePhaseChange: { newScenePhase, reader in
                    guard newScenePhase == .active,
                          validKeyboardToolbarButtons.isEmpty == false
                    else { return }

                    for platform in SearchPlatform.allCases where validKeyboardToolbarButtons.contains(platform) {
                        reader.scrollTo(platform.rawValue)
                        return
                    }
                }
            )
        )
        .onAppear {
            guard settingAutoFocus == true,
                  isPresentedSettingView == false,
                  isShowInstagramErrorAlert == false,
                  isShowPromptToConfirmDeletionOFAllHistorys == false
            else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                isFocused = true
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            guard newScenePhase == .active,
                  settingAutoFocus == true,
                  isPresentedSettingView == false,
                  isShowInstagramErrorAlert == false,
                  isShowPromptToConfirmDeletionOFAllHistorys == false,
                  safariViewURL == nil
            else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                isFocused = true
            }
        }
        .onChange(of: isPresentedSettingView) { newValue in
            if newValue == true { isFocused = false }
        }
        .onChange(of: userInput) { _ in
            guard userInput.isEmpty == false else { return }
            Task { await getSuggestion(from: userInput) }
        }
        .fullScreenCover(item: $safariViewURL) { item in
            SafariView(url: item.url)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isPresentedSettingView) {
            fetchValidKeyboardToolbarButtons()
            guard settingAutoFocus else { return }
            isFocused = true
        } content: {
            SettingView()
        }
        .alert("確認", isPresented: $isShowPromptToConfirmDeletionOFAllHistorys) {
            Button("実行", role: .destructive) {
                removeAllHistorys()
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("全履歴を削除しますか？")
        }
        .alert("Instagram検索ではスペースを使用できません。", isPresented: $isShowInstagramErrorAlert, actions: EmptyView.init)
    }
}

#Preview {
    ContentView()
}
