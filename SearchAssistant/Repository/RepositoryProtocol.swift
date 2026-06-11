import Foundation

protocol RepositoryProtocol {
    associatedtype Value
    func fetch() throws -> Value
    func save(_ value: Value) throws
}
