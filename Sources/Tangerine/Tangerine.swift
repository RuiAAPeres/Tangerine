import SwiftUI
import Combine

public struct RemoteImage: View {
    
    private let viewModel: RemoteImageViewModel
    private let placeholder: Image
    
    public init(url: URL,
                placeholder: Image) {
        self.viewModel = RemoteImageViewModel(url: url)
        self.placeholder = placeholder
    }
    
    public var body: some View {
        image
            .onAppear(perform: viewModel.refresh)
    }
    
    var image: some View {
        if let image = viewModel.image {
            return Image(uiImage: image)
        }
        else {
            return placeholder
        }
    }
}

private class RemoteImageViewModel: ObservableObject {
    
    private let url: URL
    private var cancellable: AnyCancellable?
    
    @Published var image: UIImage? = nil
    
    init(url: URL) {
        self.url = url
    }
    
    func refresh() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map {$0.data}
            .map(UIImage.init(data:))
            .catch { _ in Empty<UIImage?, Never>() }
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}
