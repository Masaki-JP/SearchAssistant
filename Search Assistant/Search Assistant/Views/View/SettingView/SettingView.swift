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

    var body: some View {
        NavigationStack {
            List {
                // フォーカス制御セクション
                Section {
                    Toggle(isOn: vm.$settingAutoFocus) {
                        Text("キーボードの自動表示")
                    }.tint(.green)
                } header: {
                    Text("キーボード")
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
                    ForEach(SASerchPlatform.allCases, id: \.self) { platform in
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
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        /// このモーダルが開かれている時に
        /// SettigsViewが表示された状態でscenePhaseが.inactiveに切り替わった場合、自動的に閉じるようにする
        .onChange(of: scenePhase) { newScene in
            guard newScene == .inactive else { return }
            vm.isPresentedSettingView = false
        }
    }
}

#Preview {
    SettingView(vm: ContentViewModel())
}
