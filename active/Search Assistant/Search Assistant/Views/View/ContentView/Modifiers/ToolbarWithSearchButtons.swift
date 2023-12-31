import SwiftUI

// キーボードツールバーにプラットフォーム別検索ボタンを追加
struct ToolbarWithSearchButtons: ViewModifier {
    @ObservedObject private(set) var vm: ViewModel
    @FocusState private(set) var isFocused

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        SearchButtonsForToolbar(vm: vm)
                        Button("完了") {
                            isFocused = false
                        }
                    }
                }
            }
    }
}

fileprivate struct SearchButtonsForToolbar: View {
    @ObservedObject private(set) var vm: ViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Platform.allCases, id: \.self) { platform in
                        if vm.keyboardToolbarButtons.validButtons.contains(platform) {
                            Button(platform.rawValue) {
                                vm.search(vm.userInput, on: platform)
                            }
                            .id(platform.rawValue)
                        }
                    }
                }
            }
            .onChange(of: scenePhase) { newScenePhase in
                guard newScenePhase == .active,
                      vm.keyboardToolbarButtons.validButtons.isEmpty == false
                else { return }
                for platform in Platform.allCases where
                vm.keyboardToolbarButtons.validButtons.contains(platform) {
                    reader.scrollTo(platform.rawValue)
                    return
                }
            }
        }
    }
}
