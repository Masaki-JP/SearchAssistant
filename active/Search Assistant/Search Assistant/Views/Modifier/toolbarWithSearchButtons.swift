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
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        ScrollViewReader { reader in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    Button("Twitter") {
                                        try! vm.Search(input, platform: .twitter) // FIXME: try!
                                        // 履歴の保存処理
                                        input.removeAll(); reader.scrollTo(0);
                                    }
                                    .id(0)
                                    Button("Instagram") {
                                        try! vm.Search(input, platform: .instagram) // FIXME: try!
                                        // 履歴の保存処理
                                        input.removeAll(); reader.scrollTo(0);
                                    }
                                    Button("Amazon") {
                                        try! vm.Search(input, platform: .amazon) // FIXME: try!
                                        // 履歴の保存処理
                                        input.removeAll(); reader.scrollTo(0);
                                    }
                                    Button("YouTube") {
                                        try! vm.Search(input, platform: .youtube) // FIXME: try!
                                        // 履歴の保存処理
                                        input.removeAll(); reader.scrollTo(0);
                                    }
                                    Button("Facebook") {
                                        try! vm.Search(input, platform: .facebook) // FIXME: try!
                                        // 履歴の保存処理
                                        input.removeAll(); reader.scrollTo(0);
                                    }
                                    Button("メルカリ") {
                                        try! vm.Search(input, platform: .mercari) // FIXME: try!
                                        // 履歴の保存処理
                                        input.removeAll(); reader.scrollTo(0);
                                    }
                                    Button("ラクマ") {
                                        try! vm.Search(input, platform: .rakuma) // FIXME: try!
                                        // 履歴の保存処理
                                        input.removeAll(); reader.scrollTo(0);
                                    }
                                    Button("PayPayフリマ") {
                                        try! vm.Search(input, platform: .paypayFleaMarket) // FIXME: try!
                                        // 履歴の保存処理
                                        input.removeAll(); reader.scrollTo(0);
                                    }
                                }
                            }
                        }
                        Button("完了") {
                            isFocused = false
                        }
                    }
                }
            }
    }
}
