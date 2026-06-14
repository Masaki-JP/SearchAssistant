import Foundation

protocol RepositoryProtocol {
    associatedtype Value
    func load() throws -> Value
    func save(_ value: Value) throws
}
