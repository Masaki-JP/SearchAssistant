import SwiftUI

struct KeyboardToolbarSection: View {
    let validKeyboardToolbarButtons: [SearchPlatform]
    let action: (SearchPlatform) -> Void
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    var body: some View {
        Section {
            ForEach(SearchPlatform.allCases) { platform in
                rowButton(platform: platform, action: action)
            }
        } header: {
            Text("ツールバーボタン")
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
            feedbackGenerator.notificationOccurred(.success)
        } label: {
            HStack {
                Text(platform.displayName)
                Spacer()
                Image(systemName: "checkmark")
                    .bold(isValid)
                    .foregroundStyle(isValid ? .green : .gray)
            }
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
            }
        )
    }
}
