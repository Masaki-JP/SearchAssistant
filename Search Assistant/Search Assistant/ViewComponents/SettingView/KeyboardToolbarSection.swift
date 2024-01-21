import SwiftUI

struct KeyboardToolbarSection: View {
    @ObservedObject private(set) var settingVM: SettingViewModel

    var body: some View {
        Section {
            ForEach(SASerchPlatform.allCases, id: \.self) { platform in
                RowLikeToggleButton(
                    text: platform.rawValue,
                    isValid: settingVM.keyboardToolbarValidButtons.contains(platform),
                    action: {
                        settingVM.toggleToolbarButtonAvailability(platform)
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
    private let action: () -> Void

    init(text: String, isValid: Bool, action: @escaping () -> Void) {
        self.text = text
        self.isValid = isValid
        self.action = action
    }

    var body: some View {
        Button(
            action: { action() },
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
        KeyboardToolbarSection(settingVM: SettingViewModel())
    }
}
