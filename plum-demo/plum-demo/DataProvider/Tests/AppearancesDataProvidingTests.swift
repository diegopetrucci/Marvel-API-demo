import Combine
import XCTest
@testable import plum_demo

final class AppearancesDataProvidingTests: XCTestCase {
    func test_fetchFromAPI_isSuccessful() {
        let dataProvider = DataProvider(
            api: APIFixture(),
            persister: AppearancesPersisterFixture()
        ).appearancesDataProviding(3)

        let expectation = XCTestExpectation(description: "Publisher has completed.")

        let _ = dataProvider.fetch("aPath")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTAssert(false, error.localizedDescription)
                }
            }) { superheroes in
                XCTAssertEqual([.fixture(), .fixture(), .fixture()], superheroes)
        }
    }

    func test_fetchFromPersistance_whenAPIIsNotAvailable_isSuccessful() {
        let dataProvider = DataProvider(
            api: APIFixture(shouldReturnError: true),
            persister: AppearancesPersisterFixture()
        ).appearancesDataProviding(3)

        let expectation = XCTestExpectation(description: "Publisher has completed.")

        let _ = dataProvider.fetch("aPath")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTAssert(false, error.localizedDescription)
                }
            }) { superheroes in
                XCTAssertEqual([.fixture(), .fixture(), .fixture()], superheroes)
        }
    }

    func test_fetch_failed() {
        let dataProvider = DataProvider(
            api: APIFixture(shouldReturnError: true),
            persister: AppearancesPersisterFixture(shouldReturnError: true)
        ).appearancesDataProviding(3)

        let expectation = XCTestExpectation(description: "Publisher has not completed, as planned.")

        let _ = dataProvider.fetch("aPath")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssert(false, "Publisher should not have completed.")
                case .failure:
                    expectation.fulfill()
                }
            }) { _ in XCTAssert(false, "No superheroes array should be received.") }
    }

    func test_persist_isSuccessful() {
       let dataProvider = DataProvider(
           api: APIFixture(shouldReturnError: true),
           persister: AppearancesPersisterFixture()
       ).appearancesDataProviding(3)

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
