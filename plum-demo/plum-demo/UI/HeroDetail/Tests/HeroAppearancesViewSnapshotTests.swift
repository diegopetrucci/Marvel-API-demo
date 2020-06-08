import XCTest
import SnapshotTesting
@testable import plum_demo

final class HeroAppearancesViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_loaded() {
        assertSnapshot(
            matching: HeroAppearancesView(appearances: [.fixture(), .fixture(), .fixture()])
                .background(Colors.background)
                .frame(height: 200),
            as: .image()
        )
    }
}
