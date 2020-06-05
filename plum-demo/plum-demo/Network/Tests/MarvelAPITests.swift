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
                        XCTAssert(false, "\(error.localizedDescription)")
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
                        XCTAssert(false, "The publisher should have failed instead.")
                    }
            },
                receiveValue: { _ in XCTAssert(false, "The publisher should have failed instead.") }
            )
    }

    func test_fetchComics_successful() {
        let remote = RemoteFixture(type: .comics)
        let api = MarvelAPI(remote: remote)

        let expectation = XCTestExpectation(description: "Publisher completed.")

        let _ = api.comics(for: 3)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        XCTAssert(false, "\(error.localizedDescription)")
                    case .finished:
                        expectation.fulfill()
                    }
                },
                receiveValue: { receivedComics in
                    XCTAssertEqual(receivedComics, [.fixture(), .fixture(), .fixture()])
                }
            )
    }

    func test_fetchComics_failed() {
        let error = RemoteError.unknown
        let remote = RemoteFixture(type: .error(error))
        let api = MarvelAPI(remote: remote)

        let expectation = XCTestExpectation(description: "Publisher errored out (as expected).")

        let _ = api.comics(for: 3)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(receivedError):
                        XCTAssertEqual(APIError.remote(error), receivedError)
                        expectation.fulfill()
                    case .finished:
                        XCTAssert(false, "The publisher should have failed instead.")
                    }
            },
                receiveValue: { _ in XCTAssert(false, "The publisher should have failed instead.") }
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

        let expectation = XCTestExpectation(description: "Publisher correctly errored out.")

        let _ = api.image(for: .fixture())
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        expectation.fulfill()
                    case .finished:
                        XCTAssert(false, "The publisher should not be completing.")
                    }
                },
                receiveValue: { _ in XCTAssertNil(false, "No image should be fetched.")
                }
        )
    }
}
