import Combine
import class SwiftUI.UIImage
import class Foundation.Bundle
@testable import plum_demo

final class ImagePersisterFixture: ImagePersisterProtocol {
    private let shouldReturnError: Bool

    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
    }

    func fetch(path: String) -> AnyPublisher<UIImage, PersisterError> {
        guard shouldReturnError.isFalse else {
            return Fail<UIImage, PersisterError>(error: PersisterError.notDataToBeRetrieved).eraseToAnyPublisher()
        }

        let image = UIImage(
            named: "persister_fixture",
            in: Bundle(for: ImagePersisterFixture.self),
            compatibleWith: nil
        )!
        
        return Just(image)
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
