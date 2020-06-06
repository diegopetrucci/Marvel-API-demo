import SnapshotTesting
import XCTest
@testable import plum_demo

final class RootContainerViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_default() {
        assertSnapshot(
            matching: RootContainerView()
            .frame(height: 100),
            as: .image()
        )
    }
}
