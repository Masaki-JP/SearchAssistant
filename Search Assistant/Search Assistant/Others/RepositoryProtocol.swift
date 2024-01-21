import Foundation

protocol RepositoryProtocol {
    associatedtype ItemType
    func save(_ items: [ItemType]) throws
    func fetch() throws -> [ItemType]
}
