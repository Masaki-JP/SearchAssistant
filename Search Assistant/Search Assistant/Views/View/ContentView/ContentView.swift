import SwiftUI

struct ContentView: View {
    @ObservedObject private(set) var vm: ContentViewModel
    @FocusState private var isFocused
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack {
            SearchTextField( vm: vm, isFocused: _isFocused )
                .padding(.horizontal)
            Divider()
                .padding(.horizontal)
            if vm.userInput.isEmpty {
                HistoryList(vm: vm)
            } else {
                SuggestionList(vm: vm)
            }
        }
        .overlay(
            alignment: vm.settingLeftSearchButton == false ? .bottomTrailing : .bottomLeading
        ) {
            if isFocused == false {
                SearchButton { isFocused = true }
                    .padding(
                        vm.settingLeftSearchButton == false ? .trailing : .leading
                    )
            }
        }
        // SafariView
        .fullScreenCover(item: $vm.searcher.searchDataForSafariView) { data in
            SafariView(data.url)
                .ignoresSafeArea()
        }
        // ツールバーに検索ボタンを実装
        .modifier(
            ToolbarWithSearchButtons(vm: vm, isFocused: _isFocused )
        )
        // 入力時にSuggestionを取得
        .onChange(of: vm.userInput) { _ in
            // 協調スレッドの無駄遣い防止
            guard vm.userInput.isEmpty == false else { return }
            Task { await vm.getSuggestion(from: vm.userInput) }
        }
        // SettingsViewの表示設定
        .sheet(isPresented: $vm.isPresesntedSettingsView) {
            SettingView(vm: vm)
        }
        // オートフォーカス有効 & アプリが開かれた
        .onAppear {
            guard vm.settingAutoFocus == true,
                  vm.isPresesntedSettingsView == false,
                  vm.isShowInstagramErrorAlert == false,
                  vm.isShowPromptToConfirmDeletionOFAllHistorys == false
            else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                isFocused = true
            }
        }
        // オートフォーカスが有効 & アプリがアクティブになった
        .onChange(of: scenePhase) { newScenePhase in
            guard case .active = newScenePhase,
                  vm.settingAutoFocus == true,
                  vm.isPresesntedSettingsView == false,
                  vm.isShowInstagramErrorAlert == false,
                  vm.isShowPromptToConfirmDeletionOFAllHistorys == false,
                  vm.searcher.searchDataForSafariView == nil
            else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                isFocused = true
            }
        }
        // Instagramエラーのアラート
        .alert("Instagram検索ではスペースを使用できません。", isPresented: $vm.isShowInstagramErrorAlert) {}
        // 履歴を全削除する際の確認のアラート
        .alert("確認", isPresented: $vm.isShowPromptToConfirmDeletionOFAllHistorys) {
            Button("実行", role: .destructive) {
                vm.removeAllHistorys()
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("全履歴を削除しますか？")
        }
    }
}

#Preview {
    ContentView(vm: ContentViewModel.shared)
}
