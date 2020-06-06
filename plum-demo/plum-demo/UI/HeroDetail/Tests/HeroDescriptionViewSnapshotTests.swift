import XCTest
import SnapshotTesting
import struct SwiftUI.Color
@testable import plum_demo

final class HeroDescriptionViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_loaded() {
        assertSnapshot(
            matching: HeroDescriptionView(
                superhero: .fixture(),
                buttonText: "💪 Recruit to Squad",
                buttonBackgroundColor: Colors.buttonBackground,
                onButtonPress: {}
            )
                .background(Colors.background),
            as: .image()
        )
    }
}
