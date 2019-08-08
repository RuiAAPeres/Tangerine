import XCTest
@testable import Tangerine

final class TangerineTests: XCTestCase {
    
    private var cache: NSCache<NSString, UIImage>!
    private let url = URL(string: "http://www.tangeries.com/tangerines.png")!
    private let data = image.pngData()!

    override func setUp() {
        cache = NSCache<NSString, UIImage>()
    }

    func test_caching_set_success() {
        
        let expectation = XCTestExpectation()
        let mockedFetcher = MockFetcher(value: .success(data))
        let fetcher = ImageFetcher(url: url, session: mockedFetcher, cache: cache)
        
        fetcher.refresh()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            let key = NSString(string: self.url.absoluteString)
            let value = self.cache.object(forKey:key)
            XCTAssertNotNil(value)
            XCTAssertNotNil(fetcher.image)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2)
    }
    
    func test_caching_set_failure_badImage() {
        
        let expectation = XCTestExpectation()
        let mockedFetcher = MockFetcher(value: .success(Data()))
        let fetcher = ImageFetcher(url: url, session: mockedFetcher, cache: cache)
        
        fetcher.refresh()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            let key = NSString(string: self.url.absoluteString)
            let value = self.cache.object(forKey:key)
            XCTAssertNil(value)
            XCTAssertNil(fetcher.image)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2)
    }
    
    func test_caching_set_failure_internetError() {
        
        let expectation = XCTestExpectation()
        let mockedFetcher = MockFetcher(value: .failure(URLError.init(.init(rawValue: 400))))
        let fetcher = ImageFetcher(url: url, session: mockedFetcher, cache: cache)
        
        fetcher.refresh()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            let key = NSString(string: self.url.absoluteString)
            let value = self.cache.object(forKey:key)
            XCTAssertNil(value)
            XCTAssertNil(fetcher.image)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2)
    }
    
    func test_caching_get_success() {
        
        let expectation = XCTestExpectation()
        let mockedFetcher = MockFetcher_Crash()
        let fetcher = ImageFetcher(url: url, session: mockedFetcher, cache: cache)
        
        cache.setObject(image, forKey: NSString(string: self.url.absoluteString))
        
        fetcher.refresh()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            let key = NSString(string: self.url.absoluteString)
            let value = self.cache.object(forKey:key)
            XCTAssertNotNil(value)
            XCTAssertNotNil(fetcher.image)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2)
    }
}
