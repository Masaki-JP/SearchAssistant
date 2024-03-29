import SwiftUI

/// - Important: `ContentViewModel`は検索履歴などのデータを読み込む必要がある。そのため事前に呼び出し元でインスタンスを作成しておく。この方法をとらない場合、一瞬ではあるが`HistoryList`の`NoContentsView`が表示されてしまう。
struct ContentView: View {
    @ObservedObject private(set) var vm: ContentViewModel
    @FocusState private var isFocused: Bool
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    var body: some View {
        VStack(spacing: 0) {
            SearchTextField(vm: vm, isFocused: $isFocused)
                .padding(.horizontal)
            Divider()
                .padding(.top, 5)
            if vm.userInput.isEmpty {
                HistoryList(
                    historys: vm.historys,
                    searchAction: vm.search(_:on:),
                    removeHistoryAction: vm.removeHistory(atOffsets:),
                    isShowPromptToConfirmDeletionOfAllHistorys: $vm.isShowPromptToConfirmDeletionOFAllHistorys
                )
            } else {
                SuggestionList(
                    suggestions: vm.suggestions,
                    action: vm.search(_:on:)
                )
            }
        }
        .overlay(
            alignment:
                vm.settingLeftSearchButton == false ?
                .bottomTrailing : .bottomLeading
        ) {
            if isFocused == false {
                FocusTextFieldButton { isFocused = true }
                    .padding(
                        vm.settingLeftSearchButton == false ?
                            .trailing : .leading
                    )
            }
        }
        ///
        ///
        ///
        /// [Toolbar]
        /// ツールバー検索ボタンの実装
        .modifier(
            ImplementationButtonsOnKeyboardToolbar(
                vm: vm,
                isFocused: $isFocused
            )
        )
        ///
        ///
        ///
        /// [Observation]
        /// オートフォーカス有効 & アプリが開かれた
        .onAppear {
            guard vm.settingAutoFocus == true,
                  vm.isPresentedSettingView == false,
                  vm.isShowInstagramErrorAlert == false,
                  vm.isShowPromptToConfirmDeletionOFAllHistorys == false
            else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                isFocused = true
            }
        }
        ///
        ///
        ///
        /// [Observation]
        /// オートフォーカスが有効 & アプリがアクティブになった
        .onChange(of: scenePhase) { newScenePhase in
            guard newScenePhase == .active,
                  vm.settingAutoFocus == true,
                  vm.isPresentedSettingView == false,
                  vm.isShowInstagramErrorAlert == false,
                  vm.isShowPromptToConfirmDeletionOFAllHistorys == false,
                  vm.safariViewURL == nil
            else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                isFocused = true
            }
        }
        ///
        ///
        ///
        /// [Observation]
        /// キーボードツールバーボタンの構成が変更される可能性があるため、
        /// `SettingView`を表示する際はキーボードを閉じる仕様とする。
        .onChange(of: vm.isPresentedSettingView) { newValue in
            if newValue == true { isFocused = false }
        }
        ///
        ///
        ///
        /// [Observation]
        /// 入力時のSuggestionの取得
        .onChange(of: vm.userInput) { _ in
            guard vm.userInput.isEmpty == false else { return }
            Task { await vm.getSuggestion(from: vm.userInput) }
        }
        ///
        ///
        ///
        /// [Presentation]
        /// フルスクリーンで`SafariView`の表示を行う。
        .fullScreenCover(item: $vm.safariViewURL) { item in
            SafariView(item.url)
                .ignoresSafeArea()
        }
        ///
        ///
        ///
        /// [Presentation]
        /// `SettingsView`の表示を行う。
        .sheet(
            isPresented: $vm.isPresentedSettingView,
            onDismiss: {
                vm.fetchValidKeyboardToolbarButtons()
                guard vm.settingAutoFocus else { return }
                isFocused = true
            },
            content: {
                SettingView()
                    .preferredColorScheme(colorScheme)
            })
        ///
        ///
        ///
        /// [Message]
        /// 検索履歴の全削除を行う際に確認を行う。
        .alert(
            "確認",
            isPresented: $vm.isShowPromptToConfirmDeletionOFAllHistorys
        ) {
            Button("実行", role: .destructive) {
                vm.removeAllHistorys()
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("全履歴を削除しますか？")
        }
        ///
        ///
        ///
        /// [Message]
        /// Instagramエラー発生時にアラートを表示する。
        .alert(
            "Instagram検索ではスペースを使用できません。",
            isPresented: $vm.isShowInstagramErrorAlert
        ) {}
    }
}

#Preview {
    ContentView(vm: ContentViewModel())
}
