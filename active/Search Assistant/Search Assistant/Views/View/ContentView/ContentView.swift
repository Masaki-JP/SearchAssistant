/*

作業終了後の流れ
1. topicブランチにてコミット
2. mainブランチにチェックアウト
3. topicブランチをマージ(※1)
4. origin/mainにプッシュ
5. topicブランチにチェックアウト

※1
メジャーアップデート、マイナーアップデートの場合はタグをつける。例えば"v2.2.0"のタグをつける場合、"git tag v2.2.0"の実行後、"git push origin v2.2.0"を実行する。見た目の変更だけであれば、パッチアップデートのみとする。
 
*/

import SwiftUI
import SafariServices

struct ContentView: View {
    @ObservedObject private(set) var vm: ViewModel
    @State private var userInput = ""
    @FocusState private var isFocused
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            VStack {
                SearchTextField(
                    vm: vm,
                    userInput: $userInput,
                    isFocused: _isFocused
                )
                .padding(.horizontal)
                Divider()
                    .padding(.horizontal)
                if userInput.isEmpty {
                    HistoryList(vm: vm)
                } else {
                    SuggestionList(vm: vm, userInput: $userInput)
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
        }
        // SafariView
        .fullScreenCover(item: $vm.searcher.searchDataForSafariView) { data in
            SafariView(url: data.url)
                .ignoresSafeArea()
        }
        // ツールバーに検索ボタンを実装
        .modifier(
            ToolbarWithSearchButtons(
                vm: vm,
                userInput: $userInput,
                isFocused: _isFocused
            )
        )
        // 入力時にSuggestionを取得
        .onChange(of: userInput) { _ in
            guard !userInput.isEmpty else { return } // 協調スレッドの無駄遣い防止
            Task { await vm.getSuggestion(from: userInput) }
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
    ContentView(vm: ViewModel.shared)
}

fileprivate struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {}
}
