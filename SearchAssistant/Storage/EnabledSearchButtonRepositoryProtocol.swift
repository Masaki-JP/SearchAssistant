import Foundation
import SearchCore

typealias EnabledSearchButtonRepositoryError = EnabledSearchButtonRepository.EnabledSearchButtonRepositoryError

protocol EnabledSearchButtonRepositoryProtocol {
    func save(_ value: [SearchPlatform]) throws(EnabledSearchButtonRepositoryError)
    func load() throws(EnabledSearchButtonRepositoryError) -> [SearchPlatform]
}

struct FakeEnabledSearchButtonRepository: EnabledSearchButtonRepositoryProtocol {
    private let value: [SearchPlatform]
    
    init(returnValue value: [SearchPlatform]) {
        self.value = value
    }
    
    func save(_ value: [SearchPlatform]) throws(EnabledSearchButtonRepositoryError) {
        reportAction()
    }
    
    func load() throws(EnabledSearchButtonRepositoryError) -> [SearchPlatform] {
        value
    }
}

extension EnabledSearchButtonRepositoryProtocol where Self == EnabledSearchButtonRepository {
    static var standard: EnabledSearchButtonRepository { .init() }
    
    static func fake(returnValue: [SearchPlatform]) -> FakeEnabledSearchButtonRepository {
        .init(returnValue: returnValue)
    }
}
