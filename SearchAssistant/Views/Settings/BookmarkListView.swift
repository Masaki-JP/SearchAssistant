import SearchCore
import SwiftUI

struct BookmarkListView<BookmarkRepositoryType: BookmarkRepositoryInterface>: View {
    @State var bookmarks: [Bookmark] = []
    let bookmarkRepository: BookmarkRepositoryType
    
    var body: some View {
        List {
            Section {
                ForEach(bookmarks) { bookmark in
                    NavigationLink {
                        BookmarkFormView(defaultValue: bookmark) { userInput, platform in
                            let newOne = Bookmark(id: bookmark.id, userInput: userInput, platform: platform)
                            try bookmarkRepository.update(newOne)
                        }
                    } label: {
                        HStack(spacing: nil) {
                            FaviconImage(platform:bookmark.platform)
                            
                            Text(bookmark.userInput)
                                .lineLimit(1)
                                .padding(.leading, 4)
                        }
                    }
                    .swipeActions {
                        Button("削除", systemImage: "trash", role: .destructive) {
                            do {
                                try bookmarkRepository.remove(bookmark)
                                bookmarks.removeAll { $0.id == bookmark.id }
                            } catch {
                                reportError(error)
                            }
                        }
                    }
                }
            }
        }
        .contentMargins(.vertical, .zero, for: .automatic)
        .navigationTitle("ブックマーク")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    BookmarkFormView { userInput, platform in
                        try bookmarkRepository.add(.init(userInput: userInput, platform: platform))
                    }
                } label: {
                    Label("ブックマークを追加", systemImage: "plus")
                }
            }
        }
        .onAppear(perform: loadBookmarks)
    }
}

extension BookmarkListView {
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
    NavigationStack {
        BookmarkListView(bookmarkRepository: .fake(returnValue: Bookmark.samples))
    }
}
