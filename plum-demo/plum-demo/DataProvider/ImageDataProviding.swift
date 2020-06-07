import Combine
import class SwiftUI.UIImage
import struct Foundation.URL

// A protocol witness in place of the usual protocol
struct ImageProviding {
    let fetch: (_ path: String) -> AnyPublisher<UIImage, ImageProvidingError>
    let persist: (UIImage, _ path: String) -> AnyPublisher<Void, Never>
}

struct ImageProvider {
    private let api: API
    private let persister: ImagePersisterProtocol

    init(api: API, persister: ImagePersisterProtocol) {
        self.api = api
        self.persister = persister
    }
}

extension ImageProvider {
    var imageDataProviding: (URL) -> ImageProviding {
        return { url in
            ImageProviding(
                fetch: { path -> AnyPublisher<UIImage, ImageProvidingError> in
                    let persisterPublisher = self.persister.fetch(path: path)
                        .mapError(ImageProvidingError.error)
                        .eraseToAnyPublisher()

                    let api: AnyPublisher<UIImage, ImageProvidingError> = self.api.image(for: url)
                        .mapError(ImageProvidingError.error)
                        .catch { _ in persisterPublisher }
                        .eraseToAnyPublisher()

                    return api
            }) { image, path -> AnyPublisher<Void, Never> in
                self.persister.persist(uiImage: image, path: path)
                    .map { _ in () }
                    // It's a good question on what should happen when
                    // the app fails to persist data. Maybe some corruption?
                    // At the moment this is effectively unhandled.
                    .replaceError(with: ())
                    .eraseToAnyPublisher()
            }
        }
    }
}

enum ImageProvidingError: Error {
    case error(Error)
}

#if DEBUG
extension ImageProvider {
    var imageDataProvidingFixture: (_ shouldErrorOut: Bool) -> (_ url: URL?) -> ImageProviding {
        return { shouldErrorOut in
            return { url in
                ImageProviding(
                    fetch: { path -> AnyPublisher<UIImage, ImageProvidingError> in
                        Just(.fixture())
                            .setFailureType(to: ImageProvidingError.self)
                            .eraseToAnyPublisher()
                }) { appearances, path -> AnyPublisher<Void, Never> in
                    Just(())
                        .replaceError(with: ())
                        .eraseToAnyPublisher()
                }
            }
        }
    }
}
#endif
