import SearchCore
import SwiftUI

struct BookmarkFormView: View {
    @State var userInput: String
    @State var platform: SearchPlatform
    @State var isSaveErrorAlertPresented = false
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
    
    let defaultValue: Bookmark?
    let showsDismissButton: Bool
    let onSave: (String, SearchPlatform) throws -> Void
    
    init(
        defaultValue: Bookmark? = nil,
        showsDismissButton: Bool = false,
        onSave: @escaping (_ userInput: String, _ platform: SearchPlatform) throws -> Void
    ) {
        self._userInput = .init(wrappedValue: defaultValue?.userInput ?? "")
        self._platform = .init(wrappedValue: defaultValue?.platform ?? .google)
        self.defaultValue = defaultValue
        self.showsDismissButton = showsDismissButton
        self.onSave = onSave
    }
    
    @ScaledMetric(relativeTo: .body) var dynamicTextFieldHeight = 22.5
    
    var normalizedUserInput: String {
        userInput.split(whereSeparator: \.isWhitespace).joined(separator: " ")
    }
    
    var isConfirmButtonDisabled: Bool {
        guard normalizedUserInput.isEmpty == false else { return true }
        
        return if let defaultValue {
            defaultValue.userInput == userInput && defaultValue.platform == platform
        } else {
            false
        }
    }
    
    var body: some View {
        Form {
            Section {
                TextField("検索 / Webサイト名入力", text: $userInput)
                    .focused($isFocused)
                    .frame(height: dynamicTextFieldHeight) // ※1
                
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
        .navigationTitle(defaultValue == nil ? "ブックマークを追加" : "ブックマークを編集")
        .navigationBarTitleDisplayMode(.inline)
        .alert("保存失敗", isPresented: $isSaveErrorAlertPresented) {
            Button(role: .close, action: dismiss.callAsFunction)
        } message: {
            Text("ブックマークの保存に失敗しました。時間をおいてから再度お試しください。")
        }
        .toolbar {
            if showsDismissButton == true {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel, action: dismiss.callAsFunction)
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    do {
                        try onSave(normalizedUserInput, platform)
                        dismiss()
                    } catch {
                        reportError(error)
                        isSaveErrorAlertPresented = true
                    }
                }
                .disabled(isConfirmButtonDisabled)
            }
        }
        .task {
            if defaultValue == nil {
                try? await Task.sleep(for: .seconds(0.1))
                isFocused = true
            }
        }
    }
}

/**
 ※1: TextFieldの初回フォーカス時のサイズ変更に対応する。
 */

#if DEBUG
let defaultValue = Bookmark(userInput: "apple", platform: .google)

#Preview("Sheet") {
    @Previewable @State var isPresented = true
    
    Button("Show") {
        isPresented = true
    }
    .sheet(isPresented: $isPresented) {
        NavigationStack {
            BookmarkFormView(defaultValue: defaultValue, showsDismissButton: true) { userInput,platform in
                throw NSError()
            }
        }
    }
}

#Preview("Navigation") {
    @Previewable @State var isPresented = true
    
    NavigationStack {
        Button("Show Sheet") {
            isPresented = true
        }
        .navigationDestination(isPresented: $isPresented) {
            NavigationStack {
                BookmarkFormView(defaultValue: defaultValue) { userInput,platform in
                    throw NSError()
                }
            }
        }
    }
}
#endif
