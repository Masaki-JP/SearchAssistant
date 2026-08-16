import SearchCore
import SwiftUI

struct BookmarkFormView: View {
    @State var userInput: String
    @State var platform: SearchPlatform
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
    
    @State var error: (any Error)? = nil
    var isSaveErrorAlertPresented: Binding<Bool> {
        .init(
            get: { error != nil },
            set: { if $0 == false { error = nil } }
        )
    }
    
    let defaultValue: Bookmark?
    let onSave: (String, SearchPlatform) throws -> Void
    
    init(
        defaultValue: Bookmark? = nil,
        onSave: @escaping (_ userInput: String, _ platform: SearchPlatform) throws -> Void
    ) {
        self._userInput = .init(wrappedValue: defaultValue?.userInput ?? "")
        self._platform = .init(wrappedValue: defaultValue?.platform ?? .google)
        self.defaultValue = defaultValue
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
    
    var alertTitle: String {
        switch error as? BookmarkRepositoryError {
        case .bookmarkAlreadyExists: "ブックマークは登録済みです"
        case .bookmarkNotFound, .dataNotSet: "ブックマークが見つかりません"
        case .decodingError: "ブックマークを読み込めません"
        case .encodingError, .none: "登録失敗"
        }
    }
    
    var alertMessage: String {
        switch error as? BookmarkRepositoryError {
        case .bookmarkAlreadyExists:
            "同じ検索語句・検索先のブックマークがすでに登録されています。"
        case .bookmarkNotFound:
            "編集対象のブックマークが見つかりません。すでに解除された可能性があります。"
        case .dataNotSet:
            "登録済みのブックマークが見つかりません。"
        case .decodingError:
            "登録済みのブックマークを読み込めません。時間をおいてから再度お試しください。"
        case .encodingError, .none:
            "ブックマークの登録に失敗しました。時間をおいてから再度お試しください。"
        }
    }
    
    var shouldDismissAfterClosingAlert: Bool {
        switch error as? BookmarkRepositoryError {
        case .bookmarkAlreadyExists, .encodingError: false
        case .bookmarkNotFound, .dataNotSet, .decodingError, .none: true
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
        .alert(alertTitle, isPresented: isSaveErrorAlertPresented) {
            Button(role: .close) {
                if shouldDismissAfterClosingAlert == true { dismiss() }
            }
        } message: {
            Text(alertMessage)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    do {
                        try onSave(normalizedUserInput, platform)
                        dismiss()
                    } catch {
                        reportError(error)
                        self.error = error
                    }
                }
                .disabled(isConfirmButtonDisabled)
            }
        }
        .onAppear {
            if defaultValue == nil { isFocused = true }
        }
    }
}

/**
 ※1: TextFieldの初回フォーカス時のサイズ変更に対応する。
 */

#if DEBUG
private let defaultValue: Bookmark? = .init(userInput: "apple", platform: .google)

#Preview {
    @Previewable @State var isSheetPresented = true
    @Previewable @State var isBookmarkFormViewPresented = true
    
    Button("Show Sheet") {
        isSheetPresented = true
    }
    .sheet(isPresented: $isSheetPresented) {
        NavigationStack {
            Button("Show BookmarkFormView") {
                isBookmarkFormViewPresented = true
            }
            .inlineNavigationTitle("各種設定")
            .navigationDestination(isPresented: $isBookmarkFormViewPresented) {
                BookmarkFormView(defaultValue: defaultValue) { userInput,platform in
                    throw NSError(domain: "BookmarkFormViewPreview", code: 1)
                }
                .inlineNavigationTitle(defaultValue == nil ? "ブックマークを登録" : "ブックマークを編集")
            }
        }
    }
}
#endif
