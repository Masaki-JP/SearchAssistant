import SwiftUI
import SearchCore

struct KeyboardToolbarSection: View {
    let enabledKeyboardToolbarButtons: [SearchPlatform]
    let onPlatformButtonTapped: (SearchPlatform) -> Void
    let onKeyboardToolbarOrderButtonTapped: () -> Void
    
    var body: some View {
        Section {
            ForEach(SearchPlatform.allCases) { platform in
                rowButton(platform: platform, action: onPlatformButtonTapped)
            }
        } header: {
            HStack {
                Text("ツールバーボタン")
                Spacer()
                Button(action: onKeyboardToolbarOrderButtonTapped) {
                    HStack(spacing: 4) {
                        Text("表示順序")
                        Image(systemName: "chevron.forward.circle")
                    }
                }
            }
        } footer: {
            Text("ツールバーに表示する検索ボタンを設定できます。")
        }
    }
    
    func rowButton(
        platform: SearchPlatform,
        action: @escaping (SearchPlatform) -> Void
    ) -> some View {
        let isEnabled = enabledKeyboardToolbarButtons.contains(platform)
        
        return Button {
            action(platform)
        } label: {
            HStack {
                Text(platform.displayName)
                    .foregroundStyle(isEnabled ? .primary : .secondary)
                Spacer()
                Image(systemName: "checkmark")
                    .fontWeight(.semibold)
                    .foregroundStyle(isEnabled ? .green : .gray)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var enabledKeyboardToolbarButtons = SearchPlatform.allCases
    
    List {
        KeyboardToolbarSection(
            enabledKeyboardToolbarButtons: enabledKeyboardToolbarButtons,
            onPlatformButtonTapped: { platform in
                if enabledKeyboardToolbarButtons.contains(platform) {
                    enabledKeyboardToolbarButtons.removeAll { $0 == platform }
                } else {
                    enabledKeyboardToolbarButtons.append(platform)
                }
            },
            onKeyboardToolbarOrderButtonTapped: {}
        )
    }
}
