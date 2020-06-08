import SnapshotTesting
import XCTest
@testable import plum_demo

final class SuperheroCellSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_default() {
        assertSnapshot(
            matching: SuperheroCell(
                superhero: .fixture(),
                asyncImageView: { _, _, _ in .fixture() }
            ),
            as: .image()
        )
    }
}
