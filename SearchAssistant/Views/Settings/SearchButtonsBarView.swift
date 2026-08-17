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
                        .alignmentGuide(.listRowSeparatorLeading) { _ in -5 }
                        .alignmentGuide(.listRowSeparatorTrailing) { $0.width + 5 }
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
                .animation(.easeInOut(duration: 0.15), value: enabledSearchButtons)
            } footer: {
                Text("サーチボタンバーに表示する検索ボタンを設定できます。")
            }
        }
    }
    
    func rowButton(
        platform: SearchPlatform,
        action: @escaping (SearchPlatform) -> Void,
    ) -> some View {
        let isEnabled = enabledSearchButtons.contains(platform)
        
        return Button {
            action(platform)
        } label: {
            HStack {
                FaviconImage(platform: platform)
                    .opacity(isEnabled ? 1.0 : 0.4)
                
                Text(platform.displayName)
                    .fontWeight(isEnabled ? .medium : nil)
                    .opacity(isEnabled ? 1.0 : 0.4)
                
                Spacer()
                
                Image(systemName: "checkmark")
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                    .opacity(isEnabled ? 1.0 : 0.0)
            }
        }
        .foregroundStyle(.primary)
    }
}


#if DEBUG
private struct PreviewContent: View {
    @State var isPresented = false
    @State var enabledSearchButtons: [SearchPlatform] = [.youtube, .amazon, .mercari, .googleMaps,]
    let colorScheme: ColorScheme
    
    var body: some View {
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
                    .inlineNavigationTitle("サーチボタンバー")
                }
        }
        .preferredColorScheme(colorScheme)
    }
}

#Preview("Light") { PreviewContent(colorScheme: .light) }
#Preview("Dark") { PreviewContent(colorScheme: .dark) }
#endif
