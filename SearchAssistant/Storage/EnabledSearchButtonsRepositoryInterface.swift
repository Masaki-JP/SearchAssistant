import Foundation
import SearchCore

typealias EnabledSearchButtonsRepositoryError = EnabledSearchButtonsRepository.EnabledSearchButtonsRepositoryError

protocol EnabledSearchButtonsRepositoryInterface {
    func save(_ value: [SearchPlatform]) throws(EnabledSearchButtonsRepositoryError)
    func load() throws(EnabledSearchButtonsRepositoryError) -> [SearchPlatform]
}

struct FakeEnabledSearchButtonsRepository: EnabledSearchButtonsRepositoryInterface {
    private let value: [SearchPlatform]
    
    init(returnValue value: [SearchPlatform]) {
        self.value = value
    }
    
    func save(_ value: [SearchPlatform]) throws(EnabledSearchButtonsRepositoryError) {
        reportMockAction()
    }
    
    func load() throws(EnabledSearchButtonsRepositoryError) -> [SearchPlatform] {
        value
    }
}
