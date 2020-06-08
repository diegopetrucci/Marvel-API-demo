import Disk
import Combine
import class SwiftUI.UIImage

protocol ImagePersisterProtocol {
    func fetch(path: String) -> AnyPublisher<UIImage, PersisterError>
    func persist(uiImage: UIImage, path: String) -> AnyPublisher<Void, PersisterError>
}

struct ImagePersister: ImagePersisterProtocol {
    func fetch(path: String) -> AnyPublisher<UIImage, PersisterError> {
        do {
            let image = try Disk.retrieve(path, from: .caches, as: UIImage.self)
            return Just(image)
                .setFailureType(to: PersisterError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail<UIImage, PersisterError>(error: .notDataToBeRetrieved)
                .eraseToAnyPublisher()
        }
    }

    func persist(uiImage: UIImage, path: String) -> AnyPublisher<Void, PersisterError> {
        do {
            // Invalidate elements that are already present.
            try? Disk.remove(path, from: .caches)
            
            try Disk.save(uiImage, to: .caches, as: path)
            return Just(())
                .setFailureType(to: PersisterError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail<Void, PersisterError>(error: .failedToPersist)
                .eraseToAnyPublisher()

        }
    }
}
