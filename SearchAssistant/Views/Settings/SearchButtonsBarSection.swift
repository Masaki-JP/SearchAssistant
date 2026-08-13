import SwiftUI
import SearchCore

struct SearchButtonsBarSection: View {
    let enabledSearchButtons: [SearchPlatform]
    let onPlatformButtonTapped: (SearchPlatform) -> Void
    let onSearchButtonsBarOrderSaved: ([SearchPlatform]) throws -> Void
    
    var body: some View {
        Section {
            NavigationLink("サーチボタンバーを編集") {
                Form {
                    Section {
                        ForEach(SearchPlatform.allCases) { platform in
                            rowButton(platform: platform, action: onPlatformButtonTapped)
                        }
                    } header: {
                        HStack {
                            Text("表示するプラットフォーム")
                            Spacer()
                            
                            NavigationLink {
                                ReorderableListView(defaultValue: enabledSearchButtons) { platform in
                                    Text(platform.displayName)
                                } sectionHeader: {
                                    Text("サーチボタンバー")
                                } sectionFooter: {
                                    Text("サーチボタンバーに表示する検索ボタンの並び順を設定できます。")
                                } onSave: { reorderedButtons in
                                    try onSearchButtonsBarOrderSaved(reorderedButtons)
                                }
                                .navigationTitle("表示順序")
                            } label: {
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
                .navigationTitle("サーチボタンバー")
            }
        } header: {
            Text("サーチボタンバー")
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
    @Previewable @State var enabledSearchButtons = SearchPlatform.allCases
    
    NavigationStack {
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
                onSearchButtonsBarOrderSaved: { reorderedButtons in
                    enabledSearchButtons = reorderedButtons
                }
            )
        }
    }
}
