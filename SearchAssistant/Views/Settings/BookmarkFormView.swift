import SearchCore
import SwiftUI

struct BookmarkFormView: View {
    @State var userInput: String
    @State var platform: SearchPlatform
    @Environment(\.dismiss) var dismiss
    
    let isNewBookmark: Bool
    let showsDismissButton: Bool
    let onConfirm: () -> Void
    
    init(defaultValue: Bookmark? = nil, showsDismissButton: Bool = false, onConfirm: @escaping () -> Void) {
        self._userInput = .init(wrappedValue: defaultValue?.userInput ?? "")
        self._platform = .init(wrappedValue: defaultValue?.platform ?? .google)
        self.isNewBookmark = defaultValue == nil
        self.showsDismissButton = showsDismissButton
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        Form {
            Section {
                TextField("検索 / Webサイト名入力", text: $userInput)
                
                Picker("検索先", selection: $platform) {
                    ForEach(SearchPlatform.allCases) { platform in
                        Text(platform.displayName)
                            .tag(platform)
                    }
                }
            } header: {
                Text("ブックマーク")
            }
        }
        .navigationTitle(isNewBookmark ? "ブックマークを追加" : "ブックマークを変更")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if showsDismissButton == true {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .cancel, action: dismiss.callAsFunction)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .confirm, action: {})
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookmarkFormView {}
    }
}
