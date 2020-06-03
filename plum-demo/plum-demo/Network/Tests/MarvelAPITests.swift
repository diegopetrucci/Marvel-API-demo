import XCTest
import Combine
@testable import plum_demo

final class MarvelAPITests: XCTestCase {
    func test_fetchCharacters_successful() {
        let remote = RemoteFixture(type: .characters)
        let api = MarvelAPI(remote: remote)

        let expectation = XCTestExpectation(description: "Publisher completed.")

        let _ = api.characters()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        fatalError(error.localizedDescription)
                    case .finished:
                        expectation.fulfill()
                    }
                },
                receiveValue: { receivedCharacters in
                    XCTAssertEqual(receivedCharacters, [.fixture(), .fixture(), .fixture()])
                }
            )
    }

    func test_fetchCharacters_failed() {
        let error = RemoteError.unknown
        let remote = RemoteFixture(type: .error(error))
        let api = MarvelAPI(remote: remote)

        let expectation = XCTestExpectation(description: "Publisher errored out (as expected).")

        let _ = api.characters()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(receivedError):
                        XCTAssertEqual(APIError.remote(error), receivedError)
                        expectation.fulfill()
                    case .finished:
                        fatalError("The publisher should have failed instead.")
                    }
            },
                receiveValue: { _ in fatalError("The publisher should have failed instead.") }
            )
    }

    func test_fetchCharacterDetail_successful() {
        let remote = RemoteFixture(type: .characterDetail)
        let api = MarvelAPI(remote: remote)

        let expectation = XCTestExpectation(description: "Publisher completed.")

        let _ = api.characterDetail(for: 3)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        fatalError(error.localizedDescription)
                    case .finished:
                        expectation.fulfill()
                    }
                },
                receiveValue: { receivedCharacterDetail in
                    XCTAssertEqual(receivedCharacterDetail, .fixture())
                }
            )
    }

    func test_fetchCharacterDetail_failed() {
        let error = RemoteError.unknown
        let remote = RemoteFixture(type: .error(error))
        let api = MarvelAPI(remote: remote)

        let expectation = XCTestExpectation(description: "Publisher errored out (as expected).")

        let _ = api.characterDetail(for: 3)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(receivedError):
                        XCTAssertEqual(APIError.remote(error), receivedError)
                        expectation.fulfill()
                    case .finished:
                        fatalError("The publisher should have failed instead.")
                    }
            },
                receiveValue: { _ in fatalError("The publisher should have failed instead.") }
            )
    }

    func test_fetchImage_successful() {
        let remote = RemoteFixture(type: .image)
        let api = MarvelAPI(remote: remote)

        let expectation = XCTestExpectation(description: "Publisher completed.")

        let _ = api.image(for: .fixture())
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        fatalError(error.localizedDescription)
                    case .finished:
                        expectation.fulfill()
                    }
                },
                receiveValue: { receivedImage in
                    XCTAssertNotNil(receivedImage)
                }
        )
    }

    func test_fetchImage_failure() {
        let remote = RemoteFixture(type: .error(.unknown))
        let api = MarvelAPI(remote: remote)

        let expectation = XCTestExpectation(description: "Publisher completed.")

        let _ = api.image(for: .fixture())
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        fatalError(error.localizedDescription)
                    case .finished:
                        expectation.fulfill()
                    }
                },
                receiveValue: { receivedImage in
                    XCTAssertNil(receivedImage)
                }
        )
    }
}

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
        case .characterDetail:
            return Just(CharacterDetail.fixture() as? T)
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
        case .characters, .characterDetail:
            fatalError("Please use `load(url:jsonDecoder:)` instead.")
        }
    }

    enum FixtureType {
        case characters
        case characterDetail
        case image
        case error(RemoteError)
    }
}
