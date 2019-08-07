import SwiftUI
import Combine

public class ImageRepository: ObservableObject {
    
    private let url: URL
    private var cancellable: AnyCancellable?
    
    @Published public private(set) var image: UIImage? = nil
    
    init(url: URL) {
        self.url = url
    }
    
    public func refresh() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
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
