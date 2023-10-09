//
//  toolbarWithSearchButtons.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/04.
//

import SwiftUI

// キーボードツールバーにプラットフォーム別検索ボタンを追加
struct toolbarWithSearchButtons: ViewModifier {
    // ビューモデル
    @ObservedObject var vm: ViewModel
    
    
    // ビュープロパティ
    @Binding var input: String
    @FocusState var isFocused
    @Environment(\.scenePhase) private var scenePhase
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack { // First HStack
                        ScrollViewReader { reader in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack { // Second HStack
                                    Button("Twitter") {
                                        vm.Search(input, platform: .twitter)
                                        input.removeAll();
                                    }
                                    .id(0)
                                    Button("Instagram") {
                                        vm.Search(input, platform: .instagram)
                                        input.removeAll();
                                    }
                                    Button("Amazon") {
                                        vm.Search(input, platform: .amazon)
                                        input.removeAll();
                                    }
                                    Button("YouTube") {
                                        vm.Search(input, platform: .youtube)
                                        input.removeAll();
                                    }
                                    Button("Facebook") {
                                        vm.Search(input, platform: .facebook)
                                        input.removeAll();
                                    }
                                    Button("メルカリ") {
                                        vm.Search(input, platform: .mercari)
                                        input.removeAll();
                                    }
                                    Button("ラクマ") {
                                        vm.Search(input, platform: .rakuma)
                                        input.removeAll();
                                    }
                                    Button("PayPayフリマ") {
                                        vm.Search(input, platform: .paypayFleaMarket)
                                        input.removeAll();
                                    }
                                    
                                } // Second HStack
                                .font(.body)
                            } // ScrollView
                            .onChange(of: scenePhase) { newValue in
                                guard case .active = newValue else { return }
                                reader.scrollTo(0)
                            }
                        } // ScrollViewReader
                        Button("完了") {
                            isFocused = false
                        }.font(.body)
                    } // First HStack
                } //ToolbarItemGroup
            } // toolbar
    } // body
}
