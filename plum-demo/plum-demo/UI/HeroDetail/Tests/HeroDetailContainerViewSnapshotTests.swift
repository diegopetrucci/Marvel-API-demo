import XCTest
import SnapshotTesting
import struct SwiftUI.Color
@testable import plum_demo

final class HeroDetailContainerViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_loaded() {
        assertSnapshot(
            matching: HeroDetailContainerView(
                superhero: .fixture(),
                mySquad: [.fixture(), .fixture(), .fixture()]
            )
                .background(Colors.background),
            as: .image()
        )
    }
}
