import SwiftUI

// キーボードツールバーにプラットフォーム別検索ボタンを追加
struct ImplementationButtonsOnKeyboardToolbar: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    var isFocused: FocusState<Bool>.Binding
    let platforms: [SearchPlatform]
    let onButtonTapped: (SearchPlatform) -> Void
    let onScenePhaseChange: (ScenePhase, ScrollViewProxy) -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        ScrollViewReader { reader in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(platforms) { platform in
                                        Button(platform.displayName) {
                                            onButtonTapped(platform)
                                        }
                                    }
                                }
                            }
                            .onChange(of: scenePhase) { newScenePhase in
                                onScenePhaseChange(newScenePhase, reader)
                            }
                        }
                        Button("完了") {
                            isFocused.wrappedValue = false
                        }
                    }
                }
        }
    }
}
