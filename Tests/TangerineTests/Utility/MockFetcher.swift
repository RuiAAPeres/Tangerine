import Foundation
import Combine
@testable import Tangerine

class MockFetcher: Fetcher {

    private let value: Result<Data, URLError>
    
    init(value: Result<Data, URLError>) {
        self.value = value
    }
    
    func dataTaskPublisher(for url: URL) -> AnyPublisher<Data, URLError> {
        return value.publisher.eraseToAnyPublisher()
    }
}

class MockFetcher_Crash: Fetcher {

    init() {}
    
    func dataTaskPublisher(for url: URL) -> AnyPublisher<Data, URLError> {
        fatalError("This shouldn't be called")
    }
}
