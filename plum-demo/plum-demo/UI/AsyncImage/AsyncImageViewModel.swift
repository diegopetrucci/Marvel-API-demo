import SwiftUI
import Combine

class AsyncImageFetcher {
    private let cache = NSCache<NSURL, UIImage>()
    
    func image(for url: URL) -> AnyPublisher<UIImage, Never> {
        return Deferred { () -> AnyPublisher<UIImage, Never> in
            if let image = self.cache.object(forKey: url as NSURL) {
                return Result.Publisher(image)
                    .eraseToAnyPublisher()
            }

            return URLSession.shared
                .dataTaskPublisher(for: url)
                .map { $0.data }
                .compactMap(UIImage.init(data:))
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput: { image in
                    self.cache.setObject(image, forKey: url as NSURL)
                })
                .ignoreError()
        }
        .eraseToAnyPublisher()
    }
}

struct AsyncImageFetcherKey: EnvironmentKey {
    static let defaultValue: AsyncImageFetcher = AsyncImageFetcher()
}

extension EnvironmentValues {
    var imageFetcher: AsyncImageFetcher {
        get {
            return self[AsyncImageFetcherKey.self]
        }
        set {
            self[AsyncImageFetcherKey.self] = newValue
        }
    }
}
