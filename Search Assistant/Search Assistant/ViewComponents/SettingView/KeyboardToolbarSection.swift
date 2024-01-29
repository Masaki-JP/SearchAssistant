import SwiftUI

struct KeyboardToolbarSection: View {
    private let validKeyboardToolbarButtons: Set<SerchPlatform>
    private let action: @MainActor (SerchPlatform) -> Void
    private let feedbackGenerator = UINotificationFeedbackGenerator()

    init(
        validKeyboardToolbarButtons: Set<SerchPlatform>,
        action: @escaping @MainActor (SerchPlatform) -> Void
    ) {
        self.validKeyboardToolbarButtons = validKeyboardToolbarButtons
        self.action = action
    }

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
    private let text: String
    private let isValid: Bool
    private let action: @MainActor () -> Void
    private let feedbackAction: () -> Void

    init(
        text: String,
        isValid: Bool,
        action: @escaping @MainActor () -> Void,
        feedbackAction: @escaping () -> Void
    ) {
        self.text = text
        self.isValid = isValid
        self.action = action
        self.feedbackAction = feedbackAction
    }

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
