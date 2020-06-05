import Combine
import class SwiftUI.UIImage

struct AppearancesPersisterFixture: PersisterProtocol {
    private let shouldReturnError: Bool

    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
    }

    func fetch<T: Codable>(type: T.Type, path: String) -> AnyPublisher<T, PersisterError> {
        guard shouldReturnError.isFalse else {
            return Fail<T, PersisterError>(error: PersisterError.notDataToBeRetrieved).eraseToAnyPublisher()
        }

        let appearances: [Appearance] = [.fixture(), .fixture(), .fixture()]

        return Just(appearances as! T)
            .setFailureType(to: PersisterError.self)
            .eraseToAnyPublisher()
    }

    func persist<T: Codable>(t: T, path: String) -> AnyPublisher<Void, PersisterError> {
        guard shouldReturnError.isFalse else {
            return Fail<Void, PersisterError>(error: PersisterError.notDataToBeRetrieved).eraseToAnyPublisher()
        }

        return Just(()).setFailureType(to: PersisterError.self).eraseToAnyPublisher()
    }
}
