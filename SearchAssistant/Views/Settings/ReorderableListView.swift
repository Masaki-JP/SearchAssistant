import SearchCore
import SwiftUI

struct ReorderableListView<Item: Identifiable & Equatable, RowContent: View, Header: View, Footer: View>: View {
    @State var items: [Item]
    @State var isSaveErrorAlertPresented = false
    @Environment(\.dismiss) var dismiss
    
    let defaultValue: [Item]
    let rowContent: (Item) -> RowContent
    let sectionHeader: () -> Header
    let sectionFooter: () -> Footer
    let saveAction: ([Item]) throws -> Void
    
    init(
        defaultValue: [Item],
        @ViewBuilder rowContent: @escaping (Item) -> RowContent,
        @ViewBuilder sectionHeader: @escaping () -> Header = EmptyView.init,
        @ViewBuilder sectionFooter: @escaping () -> Footer = EmptyView.init,
        onSave: @escaping ([Item]) throws -> Void,
    ) {
        self._items = .init(wrappedValue: defaultValue)
        self.defaultValue = defaultValue
        self.saveAction = onSave
        self.rowContent = rowContent
        self.sectionHeader = sectionHeader
        self.sectionFooter = sectionFooter
    }
    
    var body: some View {
        List {
            Section {
                ForEach(items) { item in
                    rowContent(item)
                }
                .onMove { source, destination in
                    items.move(fromOffsets: source, toOffset: destination)
                }
            } header: {
                sectionHeader()
            } footer: {
                sectionFooter()
            }
        }
        .environment(\.editMode, .constant(.active))
        .alert("保存失敗", isPresented: $isSaveErrorAlertPresented) {
            Button(role: .close, action: dismiss.callAsFunction)
        } message: {
            Text("表示順序の保存に失敗しました。時間をおいてから再度お試しください。")
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    do {
                        try saveAction(items)
                        dismiss()
                    } catch {
                        reportError(error)
                        isSaveErrorAlertPresented = true
                    }
                }
                .disabled(items == defaultValue)
            }
        }
    }
}

#if DEBUG
#Preview("SearchPlatform") {
    @Previewable @State var isPresented = false
    
    NavigationStack {
        Button("Show Sheet") {
            isPresented = true
        }
        .navigationDestination(isPresented: $isPresented) {
            NavigationStack {
                ReorderableListView(defaultValue: SearchPlatform.allCases) { platform in
                    Text(platform.displayName)
                } sectionHeader: {
                    Text("サーチボタンバー")
                } sectionFooter: {
                    Text("サーチボタンバーに表示する検索ボタンの並び順を設定できます。")
                } onSave: { _ in
                    print("called save action")
                }
                .navigationTitle("表示順序")
            }
        }
    }
    .task {
        try? await Task.sleep(for: .seconds(0.1))
        isPresented = true
    }
}

#Preview("Bookmark") {
    @Previewable @State var isPresented = false
    
    NavigationStack {
        Button("Show Sheet") {
            isPresented = true
        }
        .navigationDestination(isPresented: $isPresented) {
            NavigationStack {
                ReorderableListView(defaultValue: Bookmark.samples) { bookmark in
                    HStack(spacing: nil) {
                        FaviconImage(platform: bookmark.platform)
                        
                        Text(bookmark.userInput)
                            .lineLimit(1)
                            .padding(.leading, 4)
                    }
                } sectionHeader: {
                    Text("保存済みブックマーク")
                } onSave: { _ in
                    print("called save action")
                }
                .navigationTitle("表示順序")
            }
        }
    }
    .task {
        try? await Task.sleep(for: .seconds(0.1))
        isPresented = true
    }
}
#endif
