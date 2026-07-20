import Foundation
import SearchCore

typealias EnabledSearchButtonRepositoryError = EnabledSearchButtonRepository.EnabledSearchButtonRepositoryError

protocol EnabledSearchButtonRepositoryInterface {
    func save(_ value: [SearchPlatform]) throws(EnabledSearchButtonRepositoryError)
    func load() throws(EnabledSearchButtonRepositoryError) -> [SearchPlatform]
}

struct FakeEnabledSearchButtonRepository: EnabledSearchButtonRepositoryInterface {
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

extension EnabledSearchButtonRepositoryInterface where Self == EnabledSearchButtonRepository {
    static var standard: EnabledSearchButtonRepository { .init() }
    
    static func fake(returnValue: [SearchPlatform]) -> FakeEnabledSearchButtonRepository {
        .init(returnValue: returnValue)
    }
}
