import Combine
import struct Foundation.URL
import class Foundation.Bundle
import class SwiftUI.UIImage
@testable import plum_demo

final class APIFixture: API {
    private let shouldReturnError: Bool

    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
    }

    func characters() -> AnyPublisher<[CharacterDTO], APIError> {
        guard shouldReturnError.isFalse else {
            return Fail<[CharacterDTO], APIError>(error: APIError.remote(.unknown)).eraseToAnyPublisher()
        }

        let characters: [CharacterDTO] = [.fixture(), .fixture(), .fixture()]
        return Just(characters).setFailureType(to: APIError.self).eraseToAnyPublisher()
    }

    func comics(for characterID: Int) -> AnyPublisher<[ComicDTO], APIError> {
        guard shouldReturnError.isFalse else {
            return Fail<[ComicDTO], APIError>(error: APIError.remote(.unknown)).eraseToAnyPublisher()
        }

        let comics: [ComicDTO] = [.fixture(), .fixture(), .fixture()]
        return Just(comics).setFailureType(to: APIError.self).eraseToAnyPublisher()
    }

    func image(for url: URL) -> AnyPublisher<UIImage, APIError> {
        guard shouldReturnError.isFalse else {
            return Fail<UIImage, APIError>(error: .malformedData).eraseToAnyPublisher()
        }

        let image = UIImage(
            named: "api_fixture",
            in: Bundle(for: APIFixture.self),
            compatibleWith: nil
        )!

        return Just(image)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }


}
