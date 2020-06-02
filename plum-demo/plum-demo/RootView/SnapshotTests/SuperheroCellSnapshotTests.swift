import SnapshotTesting
import XCTest
import struct SwiftUI.Color
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
                backgroundColor: Color(red: 54 / 255, green: 59 / 255, blue: 69 / 255)
            ),
            as: .image()
        )
    }
}
