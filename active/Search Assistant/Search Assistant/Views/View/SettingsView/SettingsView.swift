//
//  SettingsView.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/08.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: ViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack {
            List {
                
//                // スプラッシュスクリーンセクション
//                Section {
//                    Toggle(isOn: $xxx) {
//                        Text("スプラッシュスクリーン")
//                    }.tint(.green)
//                } header: {
//                    Text("起動時設定")
//                } footer: {
//                    Text("アプリ起動時にスプラッシュスクリーンを表示します。")
//                }
                
                // フォーカス制御セクション
                Section {
                    Toggle(isOn: vm.$settingAutoFocus) {
                        Text("オートフォーカス")
                    }.tint(.green)
                } header: {
                    Text("フォーカス制御")
                } footer: {
                    Text("検索画面が表示された時に、検索フォームに自動でフォーカスします。")
                }
                
                // 検索ボタンセクション
                Section {
                    Toggle(isOn: vm.$settingLeftSearchButton) {
                        Text("左利き用の配置")
                    }.tint(.green)
                } header: {
                    Text("検索ボタン")
                } footer: {
                    Text("検索ボタンを画面左下に配置します。")
                }
                
                
//                // 外観モードセクション(未実装)
//                Section {
//                    Text("ライト")
//                    Text("ダーク")
//                    Text("システム")
//                } header: {
//                    Text("外観モード(未実装)")
//                } footer: {
//                    Text("iPhoneの外観モードと同じものにするにはシステムを選択してください。")
//                }
                
                
//                // キーボードツールバーセクション(未実装)
//                Section {
//                    Text("Twitter")
//                    Text("Instagram")
//                    Text("Amazon")
//                    Text("YouTube")
//                    Text("Facebook")
//                    Text("メルカリ")
//                    Text("ラクマ")
//                    Text("PayPayフリマ")
//                } header: {
//                    Text("キーボードツールバー(未実装)")
//                } footer: {
//                    Text("ツールバーに表示する検索ボタンを設定できます。設定できるのは最大で3種類までです。")
//                }
                
                
            } // List
            .navigationTitle("Settings")
        } // NabigationStack
        ///
        ///
        ///
        ///
        /// SettigsViewが表示された状態でscenePhaseが.inactiveに切り替わった場合、自動的に閉じるようにする
        .onChange(of: scenePhase) { newValue in
            if case .inactive = newValue {
                vm.isPresesntedSettingsView = false
            }
        }
        ///
        ///
        ///
    } // body
}

#Preview {
    SettingsView(vm: ViewModel.shared)
}
