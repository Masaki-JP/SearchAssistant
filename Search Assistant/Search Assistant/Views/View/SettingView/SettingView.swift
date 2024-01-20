import SwiftUI

enum SAColorScheme: String {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}

struct SettingView: View {
    @AppStorage("colorScheme") private var appStorageColorScheme = SAColorScheme.dark.rawValue
    @AppStorage("openInSafariView") private var openInSafariView = true
    @ObservedObject private(set) var vm: ContentViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ///
                ///
                /// フォーカス制御セクション
                Section {
                    Toggle(isOn: vm.$settingAutoFocus) {
                        Text("キーボードの自動表示")
                    }.tint(.green)
                } header: {
                    Text("キーボード")
                } footer: {
                    Text("検索画面が表示された時に、検索フォームに自動でフォーカスします。")
                }
                ///
                ///
                /// 検索ボタンセクション
                Section {
                    Toggle(isOn: vm.$settingLeftSearchButton) {
                        Text("左利き用の配置")
                    }.tint(.green)
                } header: {
                    Text("検索ボタン")
                } footer: {
                    Text("検索ボタンを画面左下に配置します。")
                }
                ///
                ///
                /// 外観モードセクション
                Section {
                    Picker("Color Scheme", selection: $appStorageColorScheme) {
                        Text("Light").tag(SAColorScheme.light.rawValue)
                        Text("Dark").tag(SAColorScheme.dark.rawValue)
                        Text("System").tag(SAColorScheme.system.rawValue)
                    }
                } header: {
                    Text("外観モード")
                } footer: {
                    Text("iPhoneの外観モードと同じものにするにはSystemを選択してください。")
                }
                ///
                ///
                /// ブラウザセクション
                Section {
                    Toggle("アプリ内ブラウザで開く", isOn: $openInSafariView)
                } header: {
                    Text("ブラウザ")
                } footer: {
                    Text("上記の設定をオフにした場合、検索はSafariで行われます。")
                }
                ///
                ///
                /// キーボードツールバーボタンセクション
                Section {
                    ForEach(SASerchPlatform.allCases, id: \.self) { platform in
                        RowLikeToggleButton(
                            text: platform.rawValue,
                            isValid: vm.keyboardToolbarButtons.validButtons.contains(platform),
                            action: {
                                vm.keyboardToolbarButtons.validationToggle(platform)
                            }
                        )
                    }
                } header: {
                    Text("ツールバーボタン")
                } footer: {
                    Text("ツールバーに表示する検索ボタンを設定できます。")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完了") { dismiss() }
                }
            }
        }
        ///
        ///
        /// このモーダルが表示されている時にscenePhaseがactiveでなくなった場合、自動的に閉じる処理
        .onChange(of: scenePhase) { newScene in
            guard newScene != .active else { return }
            dismiss()
        }
    }
}

extension SettingView {
    struct RowLikeToggleButton: View {
        private let text: String
        private let isValid: Bool
        private let action: () -> Void

        init(text: String, isValid: Bool, action: @escaping () -> Void) {
            self.text = text
            self.isValid = isValid
            self.action = action
        }

        var body: some View {
            Button(
                action: { action() },
                label: {
                    HStack {
                        Text(text)
                        Spacer()
                        Image(systemName: "checkmark")
                            .bold()
                            .foregroundStyle(isValid ? .green : .clear)
                    }
                })
            .foregroundStyle(.primary)
        }
    }
}

#Preview {
    SettingView(vm: ContentViewModel())
}
