import SwiftUI
import SearchCore

struct SearchButtonsBarView: View {
    let enabledSearchButtons: [SearchPlatform]
    let onPlatformButtonTapped: (SearchPlatform) -> Void
    
    var body: some View {
        Form {
            Section {
                ForEach(SearchPlatform.allCases) { platform in
                    rowButton(platform: platform, action: onPlatformButtonTapped)
                }
            } header: {
                HStack {
                    Text("表示するプラットフォーム")
                    Spacer()
                    
                    NavigationLink(value: SettingsRoute.searchButtonsBarOrder) {
                        HStack(spacing: 4) {
                            Text("表示順序")
                            Image(systemName: "chevron.forward.circle")
                        }
                    }
                    .disabled(enabledSearchButtons.count < 2)
                }
            } footer: {
                Text("サーチボタンバーに表示する検索ボタンを設定できます。")
            }
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
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    @Previewable @State var isPresented = false
    @Previewable @State var enabledSearchButtons: [SearchPlatform] = [
        .youtube, .amazon, .mercari, .googleMaps,
    ]
    
    NavigationStack {
        Text("Hello, world.")
            .task {
                try? await Task.sleep(for: .seconds(0.1))
                isPresented = true
            }
            .navigationDestination(isPresented: $isPresented) {
                SearchButtonsBarView(
                    enabledSearchButtons: enabledSearchButtons,
                    onPlatformButtonTapped: { platform in
                        if enabledSearchButtons.contains(platform) {
                            enabledSearchButtons.removeAll { $0 == platform }
                        } else {
                            enabledSearchButtons.append(platform)
                        }
                    }
                )
                .navigationTitle("サーチボタンバー")
            }
    }
}
