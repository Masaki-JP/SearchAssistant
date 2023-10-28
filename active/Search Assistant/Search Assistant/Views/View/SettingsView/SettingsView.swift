//
//  SettingsView.swift
//  Search Assistant
//
//  Created by Masaki Doi on 2023/10/08.
//

import SwiftUI

enum ColorScheme: String {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}

struct SettingsView: View {
    @AppStorage("colorScheme") var colorScheme = ColorScheme.dark.rawValue
    @AppStorage("openInSafariView") var openInSafariView = true
    
    @ObservedObject var vm: ViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack {
            List {
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
                
                
                // 外観モードセクション
                Section {
                    Picker("Color Scheme", selection: $colorScheme) {
                        Text("Light").tag(ColorScheme.light.rawValue)
                        Text("Dark").tag(ColorScheme.dark.rawValue)
                        Text("System").tag(ColorScheme.system.rawValue)
                    }
                } header: {
                    Text("外観モード")
                } footer: {
                    Text("iPhoneの外観モードと同じものにするにはSystemを選択してください。")
                }
                
                
                // ブラウザセクション
                Section {
                    Toggle("アプリ内ブラウザで開く", isOn: $openInSafariView)
                } header: {
                    Text("ブラウザ")
                } footer: {
                    Text("上記の設定をオフにした場合、検索はSafariで行われます。")
                }
                
                
                // キーボードツールバーボタンセクション
                Section {
                    ForEach(Platform.allCases, id: \.self) { platform in
                        Button(action: {
                            vm.keyboardToolbarButtons.validationToggle(platform: platform)
                        }, label: {
                            HStack {
                                Text(platform.rawValue)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .bold()
                                    .foregroundStyle(vm.keyboardToolbarButtons.validButtons.contains(platform) ? .green : .clear)
                            }
                        })
                    }
                    .foregroundStyle(.primary)
                } header: {
                    Text("ツールバーボタン")
                } footer: {
                    Text("ツールバーに表示する検索ボタンを設定できます。")
                }
                
                
            } // List
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        } // NabigationStack
        ///
        ///
        /// SettigsViewが表示された状態でscenePhaseが.inactiveに切り替わった場合、自動的に閉じるようにする
        .onChange(of: scenePhase) { newScene in
            guard case .inactive = newScene else { return }
            vm.isPresesntedSettingsView = false
        }
        ///
        ///
        /// カラースキームを変更しても、SettingsViewのカラースキームが切り替わらないことがあるので、対策として付与する
        .preferredColorScheme(
            colorScheme == "System" ? .none : colorScheme == "Light" ? .light : .dark
        )
        ///
        ///
        ///
    } // body
}

#Preview {
    SettingsView(vm: ViewModel.shared)
}
