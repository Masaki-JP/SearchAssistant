//
//  SettingView.swift
//  Search Assistant
//
//  Created by 土井正貴 on 2023/01/07.
//

import SwiftUI

struct SettingView: View {
    
    @AppStorage("autofocus") var autofocus = true
    @AppStorage("searchButton_Left") var searchButton_Left = false
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    Toggle(isOn: $autofocus) {
                        Text("オートフォーカス").fontWeight(.semibold)
                    }.tint(.green)
                } header: {
                    Text("検索フォーム")
                } footer: {
                    Text("Search Assistantが開かれたときに、検索フォームに自動でフォーカスします。")
                }
                
                Section {
                    Toggle(isOn: $searchButton_Left) {
                        Text("左利き用の配置").fontWeight(.semibold)
                    }.tint(.green)
                } header: {
                    Text("検索ボタン")
                } footer: {
                    Text("検索ボタンを画面左下に配置します。")
                }
                
                Section {
                    Text("ライト")
                    Text("ダーク")
                    Text("システム")
                } header: {
                    Text("外観モード(未実装)")
                } footer: {
                    Text("iPhoneの外観モードと同じものにするにはシステムを選択してください。")
                }
                
                Section {
                    Text("Twitter")
                    Text("Instagram")
                    Text("Amazon")
                    Text("YouTube")
                    Text("Facebook")
                    Text("メルカリ")
                    Text("ラクマ")
                    Text("PayPayフリマ")
                } header: {
                    Text("キーボードツールバー(未実装)")
                } footer: {
                    Text("ツールバーに表示する検索ボタンを設定できます。設定できるのは最大で3種類までです。")
                }
            }
            .navigationTitle("Settings")
        }
        .navigationViewStyle(.stack)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
