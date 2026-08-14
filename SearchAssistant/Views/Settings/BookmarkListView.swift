import SearchCore
import SwiftUI

struct BookmarkListView<BookmarkRepositoryType: BookmarkRepositoryInterface>: View {
    @State var bookmarks: [Bookmark] = []
    @State var isPresentedBookmarkOrderView = false
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
                NoContentView(
                    title: "登録済みブックマークはありません",
                    imageSystemName: "bookmark",
                    description: Text("右上の\u{202F}\(Image(systemName: "plus"))\u{202F}ボタンからブックマークを登録できます。")
                )
            }
        }
        .contentMargins(.vertical, .zero, for: .automatic)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("ブックマーク")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isPresentedBookmarkOrderView) {
            ReorderableListView(defaultValue: bookmarks) { bookmark in
                HStack(spacing: nil) {
                    FaviconImage(platform: bookmark.platform)
                    
                    Text(bookmark.userInput)
                        .lineLimit(1)
                        .padding(.leading, 4)
                }
            } sectionHeader: {
                Text("登録済みブックマーク")
            } onSave: { reorderedBookmarks in
                try bookmarkRepository.save(reorderedBookmarks)
                bookmarks = reorderedBookmarks
            }
            .navigationTitle("表示順序")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    BookmarkFormView { userInput, platform in
                        try bookmarkRepository.add(.init(userInput: userInput, platform: platform))
                    }
                } label: {
                    Label("ブックマークを登録", systemImage: "plus")
                }
            }
        }
        .onAppear(perform: loadBookmarks)
    }
    
    func bookmarkRowLink(_ bookmark: Bookmark) -> some View {
        NavigationLink {
            BookmarkFormView(defaultValue: bookmark) { userInput, platform in
                let updatedBookmark = Bookmark(id: bookmark.id, userInput: userInput, platform: platform)
                try bookmarkRepository.update(updatedBookmark)
            }
        } label: {
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
            Button {
                isPresentedBookmarkOrderView = true
            } label: {
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

#Preview {
    @Previewable @State var isPresented = true
    
    NavigationStack {
        Button("Show") {
            isPresented = true
        }
        .navigationDestination(isPresented: $isPresented) {
            BookmarkListView(bookmarkRepository: .fake(returnValue: Bookmark.samples))
        }
    }
}

#Preview {
    @Previewable @State var isPresented = true
    
    NavigationStack {
        Button("Show") {
            isPresented = true
        }
        .navigationDestination(isPresented: $isPresented) {
            BookmarkListView(bookmarkRepository: .fake(returnValue: .init()))
        }
    }
}
