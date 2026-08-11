import SearchCore
import SwiftUI

struct BookmarkListView<BookmarkRepositoryType: BookmarkRepositoryInterface>: View {
    @State var bookmarks: [Bookmark] = []
    @State var isPresentedBookmarkOrderView = false
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
            } header: {
                HStack {
                    Text("保存済み")
                    Spacer()
                    Button {
                        isPresentedBookmarkOrderView = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("表示順序")
                            Image(systemName: "chevron.forward.circle")
                        }
                    }
                }
            }
        }
        .contentMargins(.vertical, .zero, for: .automatic)
        .navigationTitle("ブックマーク")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isPresentedBookmarkOrderView) {
            bookmarkOrderView
                .navigationTitle("表示順序")
        }
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
    
    var bookmarkOrderView: some View {
        List {
            Section {
                ForEach(bookmarks) { bookmark in
                    HStack(spacing: nil) {
                        FaviconImage(platform: bookmark.platform)
                        
                        Text(bookmark.userInput)
                            .lineLimit(1)
                            .padding(.leading, 4)
                    }
                }
                .onMove(perform: onBookmarksMove)
            } header: {
                Text("保存済みブックマーク")
            }
        }
        .environment(\.editMode, .constant(.active))
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
    
    func onBookmarksMove(fromOffsets source: IndexSet, toOffset destination: Int) {
        let previousState = bookmarks
        bookmarks.move(fromOffsets: source, toOffset: destination)
        do {
            try bookmarkRepository.save(bookmarks)
        } catch {
            reportError(error)
            bookmarks = previousState
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
