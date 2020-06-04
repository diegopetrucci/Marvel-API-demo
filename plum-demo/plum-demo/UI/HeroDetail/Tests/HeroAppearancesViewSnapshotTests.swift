import XCTest
import SnapshotTesting
import struct SwiftUI.Color
@testable import plum_demo

final class HeroAppearancesViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_loaded() {
        assertSnapshot(
            matching: HeroAppearancesView(appearances: [.fixture(), .fixture(), .fixture()])
                .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255))
                .frame(height: 200),
            as: .image()
        )
    }
}
