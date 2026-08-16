import SearchCore
import SwiftUI

struct BookmarkListView<BookmarkRepositoryType: BookmarkRepositoryProtocol>: View {
    @State var bookmarks: [Bookmark] = []
    let bookmarkRepository: BookmarkRepositoryType
    
    var body: some View {
        List {
            if bookmarks.isEmpty == false {
                Section {
                    ForEach(bookmarks) { bookmark in
                        bookmarkRowLink(bookmark)
                            .swipeActions {
                                Button("ブックマークを解除", systemImage: "bookmark.slash", role: .destructive) {
                                    remove(bookmark: bookmark)
                                }
                                .tint(.secondary)
                            }
                    }
                } header: {
                    bookmarkSectionHeader
                } footer: {
                    Text("登録済みブックマークは、検索画面の左下の\u{202F}\(Image(systemName: "bookmark"))\u{202F}ボタンからすぐに検索できます。")
                }
            }
        }
        .overlay {
            if bookmarks.isEmpty == true {
                NoContentView.bookmark
            }
        }
        .contentMargins(.vertical, .zero, for: .automatic)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: SettingsRoute.bookmarkForm(nil)) {
                    Label("ブックマークを登録", systemImage: "plus")
                }
            }
        }
        .onAppear(perform: loadBookmarks)
    }
    
    func bookmarkRowLink(_ bookmark: Bookmark) -> some View {
        NavigationLink(value: SettingsRoute.bookmarkForm(bookmark)) {
            HStack(spacing: nil) {
                FaviconImage(platform:bookmark.platform)
                
                Text(bookmark.userInput)
                    .lineLimit(1)
                    .padding(.leading, 4)
            }
        }
    }
    
    var bookmarkSectionHeader: some View {
        HStack {
            Text("登録済み")
            Spacer()
            NavigationLink(value: SettingsRoute.bookmarkOrder(bookmarks)) {
                HStack(spacing: 4) {
                    Text("表示順序")
                    Image(systemName: "chevron.forward.circle")
                }
            }
            .disabled(bookmarks.count < 2)
        }
    }
    
}

extension BookmarkListView {
    func remove(bookmark: Bookmark) {
        do {
            try bookmarkRepository.remove(bookmark)
            bookmarks.removeAll { $0.id == bookmark.id }
        } catch {
            reportError(error)
        }
    }
    
    func loadBookmarks() {
        do {
            bookmarks = try bookmarkRepository.load()
        } catch {
            if error != .dataNotSet { reportError(error) }
            bookmarks = []
        }
    }
}

#if DEBUG
private func previewContent(
    _ bookmarks: [Bookmark], _ isPresented: Binding<Bool>, _ colorScheme: ColorScheme
) -> some View {
    NavigationStack {
        Button("Show") {
            isPresented.wrappedValue = true
        }
        .navigationDestination(isPresented: isPresented) {
            BookmarkListView(bookmarkRepository: .fake(returnValue: bookmarks))
                .inlineNavigationTitle("ブックマーク")
        }
    }
    .preferredColorScheme(colorScheme)
}

#Preview("Light 1") {
    @Previewable @State var isPresented = true
    previewContent(Bookmark.samples, $isPresented, .light)
}

#Preview("Light 2") {
    @Previewable @State var isPresented = true
    previewContent(.init(), $isPresented, .light)
}

#Preview("Dark 1") {
    @Previewable @State var isPresented = true
    previewContent(Bookmark.samples, $isPresented, .dark)
}

#Preview("Dark 2") {
    @Previewable @State var isPresented = true
    previewContent(.init(), $isPresented, .dark)
}
#endif
