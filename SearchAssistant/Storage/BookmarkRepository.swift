import Foundation

struct BookmarkRepository: BookmarkRepositoryInterface {
    private static let key = UserDefaultsKey.bookmarks
    
    enum BookmarkRepositoryError: Error {
        case bookmarkAlreadyExists
        case bookmarkNotFound
        case dataNotSet
        case decodingError
        case encodingError
    }
    
    func add(_ bookmark: Bookmark) throws(BookmarkRepositoryError) {
        var bookmarks = try loadOrEmpty()
        guard bookmarks.contains(where: { $0.userInput == bookmark.userInput && $0.platform == bookmark.platform }) == false
        else { throw BookmarkRepositoryError.bookmarkAlreadyExists }
        
        bookmarks.append(bookmark)
        try save(bookmarks)
    }
    
    func update(_ bookmark: Bookmark) throws(BookmarkRepositoryError) {
        var bookmarks = try load()
        guard let index = bookmarks.firstIndex(where: { $0.id == bookmark.id })
        else { throw BookmarkRepositoryError.bookmarkNotFound }
        guard bookmarks.contains(where: {
            $0.id != bookmark.id &&
            $0.userInput == bookmark.userInput &&
            $0.platform == bookmark.platform
        }) == false
        else { throw BookmarkRepositoryError.bookmarkAlreadyExists }
        
        bookmarks[index] = bookmark
        try save(bookmarks)
    }
    
    func remove(_ bookmark: Bookmark) throws(BookmarkRepositoryError) {
        var bookmarks = try load()
        guard let index = bookmarks.firstIndex(where: { $0.id == bookmark.id })
        else { throw BookmarkRepositoryError.bookmarkNotFound }
        
        bookmarks.remove(at: index)
        try save(bookmarks)
    }
    
    func save(_ bookmarks: [Bookmark]) throws(BookmarkRepositoryError) {
        do {
            let encodedData = try JSONEncoder().encode(bookmarks)
            UserDefaults.standard.set(encodedData, forKey: Self.key.rawValue)
        } catch {
            reportError(error)
            throw BookmarkRepositoryError.encodingError
        }
    }
    
    func load() throws(BookmarkRepositoryError) -> [Bookmark] {
        guard let itemsData = UserDefaults.standard.data(forKey: Self.key.rawValue)
        else { throw BookmarkRepositoryError.dataNotSet }
        
        do {
            return try JSONDecoder().decode([Bookmark].self, from: itemsData)
        } catch {
            reportError(error)
            throw BookmarkRepositoryError.decodingError
        }
    }
    
    private func loadOrEmpty() throws(BookmarkRepositoryError) -> [Bookmark] {
        do {
            return try load()
        } catch BookmarkRepositoryError.dataNotSet {
            return []
        }
    }
}
