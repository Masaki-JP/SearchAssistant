import Foundation

final class InMemoryUserDefaultsRepository<Value: Codable>: UserDefaultsRepositoryProtocol {
    private var value: Value
    
    init(value: Value) {
        reportMockAction()
        self.value = value
    }
    
    func save(_ value: Value) throws {
        reportMockAction()
        self.value = value
    }
    
    func fetch() throws -> Value {
        reportMockAction()
        return value
    }
}
