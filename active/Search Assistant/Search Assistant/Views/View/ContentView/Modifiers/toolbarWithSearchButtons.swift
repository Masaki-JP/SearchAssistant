import SwiftUI

// キーボードツールバーにプラットフォーム別検索ボタンを追加
struct toolbarWithSearchButtons: ViewModifier {
    // ビューモデル
    @ObservedObject private(set) var vm: ViewModel
    // ビュープロパティ
    @Binding var userInput: String
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
                                    ForEach(Platform.allCases, id: \.self) { platform in
                                        if vm.keyboardToolbarButtons.validButtons.contains(platform) {
                                            Button(platform.rawValue) {
                                                vm.search(userInput, platform: platform)
                                                userInput.removeAll()
                                            }
                                            .id(platform.rawValue)
                                        }
                                    }
                                } // Second HStack
                                .font(.body)
                            } // ScrollView
                            .onChange(of: scenePhase) { newScene in
                                guard case .active = newScene else { return }
                                guard !vm.keyboardToolbarButtons.validButtons.isEmpty else { return }
                                var completed = false
                                Platform.allCases.forEach { platform in
                                    if completed == false,
                                       vm.keyboardToolbarButtons.validButtons.contains(platform) {
                                        reader.scrollTo(platform.rawValue)
                                        completed = true
                                    }
                                }
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
