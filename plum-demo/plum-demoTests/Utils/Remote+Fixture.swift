import Combine
import Foundation
import class SwiftUI.UIImage
@testable import plum_demo

struct RemoteFixture: RemoteProtocol {
    private let type: FixtureType

    init(type: FixtureType) {
        self.type = type
    }

    func load<T: Decodable>(from request: URLRequest, jsonDecoder: JSONDecoder) -> AnyPublisher<T, RemoteError> {
        switch type {
        case .characters:
            let characters: [CharacterDTO] = [.fixture(), .fixture(), .fixture()]

            return Just(characters as? T)
                .compactMap(identity)
                .setFailureType(to: RemoteError.self)
                .eraseToAnyPublisher()
        case .comics:
            let comics: [ComicDTO] = [.fixture(), .fixture(), .fixture()]
            return Just(comics as? T)
                .compactMap(identity)
                .setFailureType(to: RemoteError.self)
                .eraseToAnyPublisher()
        case let .error(error):
            return Fail<T, RemoteError>(error: error)
                .eraseToAnyPublisher()
        case .image:
            fatalError("Please use `loadData(imageURL:)` instead.")
        }
    }

    func loadData(from imageURL: URL) -> AnyPublisher<Data, RemoteError> {
        switch type {
        case .image:
            return Just(UIImage.fixture(for: Bundle(for: MarvelAPITests.self)))
                .map { $0.pngData() }
                .compactMap(identity)
                .setFailureType(to: RemoteError.self)
                .eraseToAnyPublisher()
        case let .error(error):
            return Fail<Data, RemoteError>(error: error)
                .eraseToAnyPublisher()
        case .characters, .comics:
            fatalError("Please use `load(url:jsonDecoder:)` instead.")
        }
    }

    enum FixtureType {
        case characters
        case comics
        case image
        case error(RemoteError)
    }
}
