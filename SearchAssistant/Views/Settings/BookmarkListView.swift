import SearchCore
import SwiftUI

struct BookmarkListView: View {
    let bookmarks = Bookmark.samples
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section {
                ForEach(bookmarks) { bookmark in
                    NavigationLink {
                        BookmarkFormView(defaultValue: bookmark) {}
                    } label: {
                        HStack(spacing: nil) {
                            FaviconImage(platform:bookmark.platform)
                            
                            Text(bookmark.userInput)
                                .lineLimit(1)
                                .padding(.leading, 4)
                        }
                    }
                    .swipeActions {
                        Button("削除", systemImage: "trash", role: .destructive, action: {})
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
                    BookmarkFormView {}
                } label: {
                    Label("ブックマークを追加", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookmarkListView()
    }
}
