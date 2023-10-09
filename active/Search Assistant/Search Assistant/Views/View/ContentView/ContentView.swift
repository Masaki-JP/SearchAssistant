//
//  ContentView.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/03.
//

#warning("""

作業終了後の流れ
1. topicブランチにてコミット
2. mainブランチにチェックアウト
3. topicブランチをマージ
4. origin/mainにプッシュ
5. topicブランチにチェックアウト

""")

import SwiftUI

struct ContentView: View {
    // ビューモデル
    @ObservedObject var vm: ViewModel
    
    // ビュープロパティ
    @State var input = ""
    @FocusState var isFocused
    @Environment(\.scenePhase) private var scenePhase
    
    
    var body: some View {
        ZStack {
            // メインコンテンツエリア
            VStack {
                // テキストフィールド
                SearchTextField(vm: vm, input: $input, isFocused: _isFocused)
                .padding(.horizontal)
                
                Divider()
                
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
        
        
        /// ツールバーに検索ボタンを実装
        .modifier(toolbarWithSearchButtons(vm: vm, input: $input, isFocused: _isFocused))
        
        
        /// 入力時にSuggestionを取得
        .onChange(of: input) { _ in
            // Taskは協調スレッドを利用するため、不必要な場合はここで早期リターンする
            guard !input.isEmpty else { return }
            Task { try! await vm.getSuggestion(from: input) } // FIXME: try!
        }
        
        
        /// SettingsViewの表示設定
        .sheet(isPresented: $vm.isPresesntedSettingsView) {
            SettingsView(vm: vm)
        }
       
        
        /// オートフォーカスが有効化されていた場合の処理
        .onChange(of: scenePhase) { newValue in
            guard case .active = newValue,
                  vm.settingAutoFocus == true,
                  vm.isPresesntedSettingsView == false,
                  vm.isShowInstagramErrorAlert == false,
                  vm.isShowPromptToConfirmDeletionOFAllHistorys == false
            else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                isFocused = true
            }
        }
        
        
        /// Instagramエラーのアラート
        .alert("Instagram検索ではスペースを使用できません。", isPresented: $vm.isShowInstagramErrorAlert) {}
        
        
        /// 履歴を全削除する際の確認のアラート
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