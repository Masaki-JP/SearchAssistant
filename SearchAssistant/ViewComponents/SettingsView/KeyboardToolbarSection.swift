import SwiftUI

struct KeyboardToolbarSection: View {
    let validKeyboardToolbarButtons: Set<SearchPlatform>
    let action: (SearchPlatform) -> Void
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    var body: some View {
        Section {
            ForEach(SearchPlatform.allCases) { platform in
                SettingsRow(
                    text: platform.displayName,
                    isValid: validKeyboardToolbarButtons.contains(platform),
                    action: { action(platform) },
                    feedbackAction: { feedbackGenerator.notificationOccurred(.success) }
                )
            }
        } header: {
            Text("ツールバーボタン")
        } footer: {
            Text("ツールバーに表示する検索ボタンを設定できます。")
        }
    }
}

fileprivate struct SettingsRow: View {
    let text: String
    let isValid: Bool
    let action: () -> Void
    let feedbackAction: () -> Void
    
    var body: some View {
        Button(
            action: { action(); feedbackAction(); },
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

#Preview {
    List {
        KeyboardToolbarSection(
            validKeyboardToolbarButtons: Set(SearchPlatform.allCases),
            action: { _ in}
        )
    }
}
