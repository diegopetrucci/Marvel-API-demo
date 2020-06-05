import Combine
import Disk

protocol PersisterProtocol {
    func fetch<T: Codable>(type: T.Type, path: String) -> AnyPublisher<T, PersisterError>
    func persist<T: Codable>(t: T, path: String) -> AnyPublisher<Void, PersisterError>
}

struct Persister: PersisterProtocol {
    func fetch<T: Codable>(type: T.Type, path: String) -> AnyPublisher<T, PersisterError> {
        do {
            let t = try Disk.retrieve(path, from: .caches, as: T.self)
            return Just(t)
                .setFailureType(to: PersisterError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail<T, PersisterError>(error: .notDataToBeRetrieved)
                .eraseToAnyPublisher()
        }
    }

    func persist<T: Codable>(t: T, path: String) -> AnyPublisher<Void, PersisterError> {
        do {
            // Invalidate elements that are already present.
            try? Disk.remove(path, from: .caches)

            try Disk.save(t, to: .caches, as: path)
            return Just(())
                .setFailureType(to: PersisterError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail<Void, PersisterError>(error: .failedToPersist)
                .eraseToAnyPublisher()
        }
    }
}

enum PersisterError: Error {
    case notDataToBeRetrieved
    case failedToPersist
}
