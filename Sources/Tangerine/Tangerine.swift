import SwiftUI
import Combine

public class ImageFetcher: ObservableObject {
    
    private let url: URL
    private let session: URLSession
    private var cancellable: AnyCancellable?
    
    @Published public private(set) var image: UIImage? = nil
    
    init(url: URL,
         session: URLSession = .shared) {
        self.url = url
        self.session = session
    }
    
    public func refresh() {
        cancellable = session.dataTaskPublisher(for: url)
            .map { $0.data }
            .map(UIImage.init(data:))
            .catch { _ in Empty<UIImage?, Never>() }
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    public func cancel() {
        cancellable?.cancel()
    }
}
