import SwiftUI

struct KeyboardToolbarSection: View {
    let validKeyboardToolbarButtons: Set<SerchPlatform>
    let action: @MainActor (SerchPlatform) -> Void
    private let feedbackGenerator = UINotificationFeedbackGenerator()

    var body: some View {
        Section {
            ForEach(SerchPlatform.allCases) { platform in
                RowLikeToggleButton(
                    text: platform.rawValue,
                    isValid: validKeyboardToolbarButtons.contains(platform),
                    action: { action(platform) },
                    feedbackAction: {                        feedbackGenerator.notificationOccurred(.success)
                    }
                )
            }
        } header: {
            Text("ツールバーボタン")
        } footer: {
            Text("ツールバーに表示する検索ボタンを設定できます。")
        }
    }
}

struct RowLikeToggleButton: View {
    let text: String
    let isValid: Bool
    let action: @MainActor () -> Void
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
            validKeyboardToolbarButtons: Set(SerchPlatform.allCases),
            action: { _ in}
        )
    }
}
