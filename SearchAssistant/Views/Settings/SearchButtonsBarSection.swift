import SwiftUI
import SearchCore

struct SearchButtonsBarSection: View {
    let enabledSearchButtons: [SearchPlatform]
    let onPlatformButtonTapped: (SearchPlatform) -> Void
    let onSearchButtonsBarOrderButtonTapped: () -> Void
    
    var body: some View {
        Section {
            ForEach(SearchPlatform.allCases) { platform in
                rowButton(platform: platform, action: onPlatformButtonTapped)
            }
        } header: {
            HStack {
                Text("サーチボタンバー")
                Spacer()
                Button(action: onSearchButtonsBarOrderButtonTapped) {
                    HStack(spacing: 4) {
                        Text("表示順序")
                        Image(systemName: "chevron.forward.circle")
                    }
                }
            }
        } footer: {
            Text("サーチボタンバーに表示する検索ボタンを設定できます。")
        }
    }
    
    func rowButton(
        platform: SearchPlatform,
        action: @escaping (SearchPlatform) -> Void
    ) -> some View {
        let isEnabled = enabledSearchButtons.contains(platform)
        
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
    @Previewable @State var enabledSearchButtons = SearchPlatform.allCases
    
    List {
        SearchButtonsBarSection(
            enabledSearchButtons: enabledSearchButtons,
            onPlatformButtonTapped: { platform in
                if enabledSearchButtons.contains(platform) {
                    enabledSearchButtons.removeAll { $0 == platform }
                } else {
                    enabledSearchButtons.append(platform)
                }
            },
            onSearchButtonsBarOrderButtonTapped: {}
        )
    }
}
