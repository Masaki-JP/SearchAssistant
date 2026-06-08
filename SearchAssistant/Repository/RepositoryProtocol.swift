import Foundation

protocol RepositoryProtocol {
    associatedtype Object
    func fetch() throws -> Object
    func save(_ object: Object) throws
}
