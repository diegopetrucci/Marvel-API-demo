import XCTest
import SnapshotTesting
import struct SwiftUI.Color
@testable import plum_demo

final class PreviousIssueViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_loaded() {
        assertSnapshot(
            matching: PreviousIssueView(appearance: .fixture())
                .background(Colors.background)
            .frame(height: 500),
            as: .image()
        )
    }
}
