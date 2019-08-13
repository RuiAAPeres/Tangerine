import SwiftUI
import Combine
import Foundation

public protocol Fetcher {
  func dataTaskPublisher(for url: URL) -> AnyPublisher<Data, URLError>
}

extension URLSession: Fetcher {
  public func dataTaskPublisher(for url: URL) -> AnyPublisher<Data, URLError> {
    self.dataTaskPublisher(for: url).map(\.data).eraseToAnyPublisher()
  }
}

public class ImageFetcher: ObservableObject {
  
  private let url: URL
  private let session: Fetcher
  private let cache: NSCache<NSString, UIImage>
  private var networkCancellable: AnyCancellable?
  
  public var objectWillChange = PassthroughSubject<Void, Never>()
  
  public private(set) var image: UIImage? = nil {
    willSet {
      objectWillChange.send()
    }
  }
  
  public init(url: URL,
              session: Fetcher = URLSession.shared,
              cache: NSCache<NSString, UIImage> = NSCache()
  ) {
    self.url = url
    self.session = session
    self.cache = cache
  }
  
  public func refresh() {
    let key = NSString(string: url.absoluteString)
    
    if let cachedImage = cache.object(forKey:key) {
      image = cachedImage
    }
    else {
      networkCancellable = session.dataTaskPublisher(for: url)
        .map(UIImage.init(data:))
        .catch { _ in Empty<UIImage?, Never>() }
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveOutput: { image in
          guard let newImage = image else { return }
          self.cache.setObject(newImage, forKey: key)
        })
        .assign(to: \.image, on: self)
    }
  }
  
  public func cancel() {
    networkCancellable?.cancel()
  }
}
