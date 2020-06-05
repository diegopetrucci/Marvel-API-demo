import Combine
import XCTest
@testable import plum_demo

final class ImageDataProvidingTests: XCTestCase {
    func test_fetchFromAPI_isSuccessful() {
        let dataProvider = ImageProvider(
            api: APIFixture(),
            persister: ImagePersisterFixture()
        ).imageDataProviding(.fixture())

        let expectation = XCTestExpectation(description: "Publisher has completed.")

        let _ = dataProvider.fetch("aPath")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTAssert(false, error.localizedDescription)
                }
            }) { receivedImage in
                XCTAssertEqual(UIImage(named: "thumbnail_fixture"), receivedImage) // TODO replace with api_fixture
        }
    }

    func test_fetchFromPersistance_whenAPIIsNotAvailable_isSuccessful() {
        let dataProvider = ImageProvider(
            api: APIFixture(shouldReturnError: true),
            persister: ImagePersisterFixture()
        ).imageDataProviding(.fixture())

        let expectation = XCTestExpectation(description: "Publisher has completed.")

        let _ = dataProvider.fetch("aPath")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTAssert(false, error.localizedDescription)
                }
            }) { receivedImage in
                XCTAssertEqual(UIImage(named: "thumbnail_fixture"), receivedImage) // TODO replace with persistance_fixture
        }
    }

    func test_fetch_failed() {
        let dataProvider = ImageProvider(
            api: APIFixture(shouldReturnError: true),
            persister: ImagePersisterFixture(shouldReturnError: true)
        ).imageDataProviding(.fixture())

        let expectation = XCTestExpectation(description: "Publisher has not completed, as planned.")

        let _ = dataProvider.fetch("aPath")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssert(false, "Publisher should not have completed.")
                case .failure:
                    expectation.fulfill()
                }
            }) { _ in XCTAssert(false, "No image should be received.") }
    }

    func test_persist_isSuccessful() {
        let dataProvider = ImageProvider(
            api: APIFixture(shouldReturnError: true),
            persister: ImagePersisterFixture()
        ).imageDataProviding(.fixture())

        let expectation = XCTestExpectation(description: "Publisher has completed.")

        let _ = dataProvider.fetch("aPath")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTAssert(false, "\(error)")
                }
            }) { _ in }
    }
}
