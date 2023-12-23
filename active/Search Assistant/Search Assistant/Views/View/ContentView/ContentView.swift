
#warning("""
作業終了後の流れ
1. topicブランチにてコミット
2. mainブランチにチェックアウト
3. topicブランチをマージ
(メジャーアップデート、マイナーアップデートの場合はタグをつける。"git tag v2.2.0"の実行後、"git push origin v2.2.0"を実行する。)
4. origin/mainにプッシュ
5. topicブランチにチェックアウト
""")

import SwiftUI
import SafariServices

struct ContentView: View {
    // ビューモデル
    @ObservedObject var vm: ViewModel
    // ビュープロパティ
    @State private var input = ""
    @FocusState private var isFocused
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            // メインコンテンツエリア
            VStack {
                // テキストフィールド
                SearchTextField(vm: vm, input: $input, isFocused: _isFocused)
                    .padding(.horizontal)
                Divider().padding(.horizontal)
                // 検索履歴 or 検索候補
                if input.isEmpty {
                    HistorysList(vm: vm)
                } else {
                    SuggestionsList(vm: vm, input: $input)
                }
            } // メインコンテンツエリア
            // 検索ボタン
            if !isFocused {
                SearchButton { isFocused = true }
                    .modifier(praceAtAppropriatePositionIfInZStack(vm: vm))
            }
        } // ZStack
        // SafariView
        .fullScreenCover(item: $vm.searcher.searchDataForSafariView) { data in
            SafariView(url: data.url)
                .ignoresSafeArea()
        }
        // ツールバーに検索ボタンを実装
        .modifier(toolbarWithSearchButtons(vm: vm, input: $input, isFocused: _isFocused))
        // 入力時にSuggestionを取得
        .onChange(of: input) { _ in
            // Taskは協調スレッドを利用するため、不必要な場合はここで早期リターンする
            guard !input.isEmpty else { return }
            Task { try! await vm.getSuggestion(from: input) } // FIXME: try!
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
        .onChange(of: scenePhase) { newValue in
            guard case .active = newValue,
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
            Button("実行する", role: .destructive) {
                vm.removeAllHistorys()
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("全履歴を削除しますか？")
        }
    } // body
}

#Preview {
    ContentView(vm: ViewModel.shared)
}

/// Appにおけるウェブビューを実現するには、WKWebViewとSFSafariViewControllerのどちらを使うべきですか
/// https://developer.apple.com/jp/news/?id=trjs0tcd
/// ASWebAuthenticationSession
/// https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession
/// SFSafariViewController
/// https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller

struct SafariView: UIViewControllerRepresentable {
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
