import Combine
import class SwiftUI.UIImage
@testable import plum_demo

struct ImagePersisterFixture: ImagePersisterProtocol {
    private let shouldReturnError: Bool

    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
    }

    func fetch(path: String) -> AnyPublisher<UIImage, PersisterError> {
        guard shouldReturnError.isFalse else {
            return Fail<UIImage, PersisterError>(error: PersisterError.notDataToBeRetrieved).eraseToAnyPublisher()
        }

        return Just(UIImage(named: "thumbnail_fixture")!) // TODO change to persister_fixture
            .setFailureType(to: PersisterError.self)
            .eraseToAnyPublisher()
    }

    func persist(uiImage: UIImage, path: String) -> AnyPublisher<Void, PersisterError> {
        guard shouldReturnError.isFalse else {
            return Fail<Void, PersisterError>(error: PersisterError.notDataToBeRetrieved).eraseToAnyPublisher()
        }

        return Just(()).setFailureType(to: PersisterError.self).eraseToAnyPublisher()
    }
    

}
