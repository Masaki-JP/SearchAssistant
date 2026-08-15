import Foundation

typealias BookmarkRepositoryError = BookmarkRepository.BookmarkRepositoryError

protocol BookmarkRepositoryProtocol {
    func add(_ bookmark: Bookmark) throws(BookmarkRepositoryError)
    func load() throws(BookmarkRepositoryError) -> [Bookmark]
    func remove(_ bookmark: Bookmark) throws(BookmarkRepositoryError)
    func save(_ bookmarks: [Bookmark]) throws(BookmarkRepositoryError)
    func update(_ bookmark: Bookmark) throws(BookmarkRepositoryError)
}

/// 保存操作後の値を保持するため、クラスとして定義している。
final class FakeBookmarkRepository: BookmarkRepositoryProtocol {
    private var value: [Bookmark]
    
    init(returnValue value: [Bookmark]) {
        self.value = value
    }
    
    func add(_ bookmark: Bookmark) throws(BookmarkRepositoryError) {
        guard value.contains(where: { $0.userInput == bookmark.userInput && $0.platform == bookmark.platform }) == false
        else { throw BookmarkRepositoryError.bookmarkAlreadyExists }
        
        value.append(bookmark)
    }
    
    func remove(_ bookmark: Bookmark) throws(BookmarkRepositoryError) {
        guard let index = value.firstIndex(where: { $0.id == bookmark.id })
        else { throw BookmarkRepositoryError.bookmarkNotFound }
        
        value.remove(at: index)
    }
    
    func update(_ bookmark: Bookmark) throws(BookmarkRepositoryError) {
        guard let index = value.firstIndex(where: { $0.id == bookmark.id })
        else { throw BookmarkRepositoryError.bookmarkNotFound }
        guard value.contains(where: {
            $0.id != bookmark.id &&
            $0.userInput == bookmark.userInput &&
            $0.platform == bookmark.platform
        }) == false
        else { throw BookmarkRepositoryError.bookmarkAlreadyExists }
        
        value[index] = bookmark
    }
    
    func load() throws(BookmarkRepositoryError) -> [Bookmark] {
        value
    }
    
    func save(_ bookmarks: [Bookmark]) throws(BookmarkRepositoryError) {
        value = bookmarks
    }
}

extension BookmarkRepositoryProtocol where Self == BookmarkRepository {
    static var standard: BookmarkRepository { .init() }
    
    static func fake(returnValue: [Bookmark]) -> FakeBookmarkRepository {
        .init(returnValue: returnValue)
    }
}
