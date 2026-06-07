import Foundation

final class InMemoryUserDefaultsRepository<Item: Codable>: UserDefaultsRepositoryProtocol {
    private let dummyData: [Item]
    
    init(dummyData: [Item]) {
        reportMockAction()
        self.dummyData = dummyData
    }
    
    func save(_ items: [Item]) throws {
        reportMockAction()
    }
    
    func fetch() throws -> [Item] {
        reportMockAction()
        return dummyData
    }
}
