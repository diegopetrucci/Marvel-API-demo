import XCTest
import Combine
import Disk
@testable import plum_demo

// Integration tests
final class ImagePersisterTests: XCTestCase {
    let path = "/image/1"

    override func setUp() {
        try? Disk.remove(path, from: .caches)
    }

    func test_persist_whenDataNotPresent() {
        defer { try! Disk.remove(path, from: .caches) }

        let persister = ImagePersister()

        let expectation = XCTestExpectation(description: "Publisher completed.")

        let _ = persister.persist(uiImage: .fixture(), path: path)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    expectation.fulfill()
                }
            }) { _ in }
    }

    // This test could be merged with the previous one,
    // but I've chosen to keep them separate to be
    // slightly more precise with the errors given
    func test_persist_whenDataIsAlreadyPresent() {
        defer { try! Disk.remove(path, from: .caches) }

        let persister = ImagePersister()

        let expectation = XCTestExpectation(description: "Publisher completed.")

        // Persist the data
        let _ = persister.persist(uiImage: .fixture(), path: path)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    expectation.fulfill()
                }
            }) { _ in }
        
        // Check that it's force-persisting
        let _ = persister.persist(uiImage: .fixture(), path: "/image/1")
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    expectation.fulfill()
                }
            }) { _ in }
    }
}
