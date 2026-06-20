import SwiftUI
import SearchCore

struct KeyboardToolbarSection: View {
    let validKeyboardToolbarButtons: [SearchPlatform]
    let action: (SearchPlatform) -> Void
    let onKeyboardToolbarOrderButtonTapped: () -> Void
    
    var body: some View {
        Section {
            ForEach(SearchPlatform.allCases) { platform in
                rowButton(platform: platform, action: action)
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
        let isValid = validKeyboardToolbarButtons.contains(platform)
        
        return Button {
            action(platform)
        } label: {
            HStack {
                Text(platform.displayName)
                    .foregroundStyle(isValid ? .primary : .secondary)
                Spacer()
                Image(systemName: "checkmark")
                    .bold(isValid)
                    .foregroundStyle(isValid ? .green : .gray)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var validKeyboardToolbarButtons = SearchPlatform.allCases
    
    List {
        KeyboardToolbarSection(
            validKeyboardToolbarButtons: validKeyboardToolbarButtons,
            action: { platform in
                if validKeyboardToolbarButtons.contains(platform) {
                    validKeyboardToolbarButtons.removeAll { $0 == platform }
                } else {
                    validKeyboardToolbarButtons.append(platform)
                }
            },
            onKeyboardToolbarOrderButtonTapped: {}
        )
    }
}
