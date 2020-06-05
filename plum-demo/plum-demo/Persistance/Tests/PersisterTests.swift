import XCTest
import Combine
import Disk
@testable import plum_demo

// Integration tests
final class PersisterTests: XCTestCase {
    let path = "/path"

    override func setUp() {
        try? Disk.remove(path, from: .caches)
    }

    func test_persist_whenDataNotPresent() {
        defer { try! Disk.remove(path, from: .caches) }

        let persister = Persister()

        let expectation = XCTestExpectation(description: "Publisher completed.")

        let _ = persister.persist(t: 1, path: path)
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

        let persister = Persister()

        let expectation = XCTestExpectation(description: "Publisher completed.")

        // Persist the data
        let _ = persister.persist(t: 1, path: path)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    expectation.fulfill()
                }
            }) { _ in }
        
        // Check that is still persisting the data
        let _ = persister.persist(t: 1, path: path)
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
