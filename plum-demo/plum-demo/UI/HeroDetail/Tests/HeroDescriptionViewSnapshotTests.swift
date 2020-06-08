import XCTest
import SnapshotTesting
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
                button: .init(
                    text: "💪 Recruit to Squad",
                    backgroundColor: Colors.buttonBackground,
                    backgroundColorPressed: Colors.buttonBackgroundPressed,
                    onPress: {}
                    )
            )
                .background(Colors.background),
            as: .image()
        )
    }
}
