import SwiftUI

// キーボードツールバーにプラットフォーム別検索ボタンを追加
struct ImplementationButtonsOnKeyboardToolbar: ViewModifier {
    @ObservedObject private(set) var vm: ContentViewModel
    private var isFocused: FocusState<Bool>.Binding

    init(
        vm: ContentViewModel,
        isFocused: FocusState<Bool>.Binding
    ) {
        self.vm = vm
        self.isFocused = isFocused
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        SearchButtons(vm: vm)
                        Button("完了") {
                            isFocused.wrappedValue = false
                        }
                    }
                }
            }
    }
}

fileprivate struct SearchButtons: View {
    @ObservedObject private(set) var vm: ContentViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(SerchPlatform.allCases, id: \.self) { platform in
                        if vm.validKeyboardToolbarButtons.contains(platform) {
                            Button(platform.rawValue) {
                                vm.search(vm.userInput, on: platform)
                            }
                        }
                    }
                }
            }
            .onChange(of: scenePhase) { newScenePhase in
                guard newScenePhase == .active,
                      vm.validKeyboardToolbarButtons.isEmpty == false
                else { return }

                for platform in SerchPlatform.allCases
                where vm.validKeyboardToolbarButtons.contains(platform) {
                    reader.scrollTo(platform.rawValue)
                    return
                }
            }
        }
    }
}
