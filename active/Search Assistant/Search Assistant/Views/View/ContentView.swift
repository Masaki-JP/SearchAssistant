//
//  ContentView.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/03.
//

import SwiftUI

struct ContentView: View {
    // ビューモデル
    @StateObject var vm = ViewModel.shared
    
    // ビュープロパティ
    @State var input = ""
    @FocusState var isFocused
    
    var body: some View {
        ZStack {
            // メインコンテンツエリア
            VStack {
                // テキストフィールド
                TextField("Placeholder", text: $input)
                    .padding()
                    .focused($isFocused)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        try! vm.Search(input) // FIXME: try!
                        input.removeAll()
                    }
                    .padding(.top)
                
                // 検索履歴 or 検索候補
                ForEach(input.isEmpty ? vm.historys.indices : vm.suggestions.indices, id: \.self) { i in
                    let text = input.isEmpty ? vm.historys[i].input : vm.suggestions[i]
                    Button(text) {
                        try! vm.Search(text) // FIXME: try!
                        input.removeAll()
                    }
                }
                
                // 履歴の全削除ボタン
                if input.isEmpty {
                    Button {
                        vm.removeAllHistorys()
                    } label: {
                        Text("履歴を全て削除")
                    }
                    .buttonStyle(.borderedProminent).tint(.red).padding(.top)
                    .disabled(vm.historys.isEmpty)
                }
                
                Spacer()
            }
            
            if !isFocused {
                // 検索ボタン
                SearchButton {
                    isFocused = true
                }
                .modifier(praceAtBottomRightIfInZStack())
            }
        }
        // ツールバーに検索ボタンを実装
        .modifier(toolbarWithSearchButtons(vm: vm, input: $input, isFocused: _isFocused))
        // 入力時にSuggestionを取得
        .onChange(of: input) {
            // Taskは協調スレッドを利用するため、不必要な場合はここで早期リターンする
            guard !input.isEmpty else { return }
            Task { try! await vm.getSuggestion(from: input) } // FIXME: try!
        }
    }
}

#Preview {
    ContentView()
}
