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
                dataProviding: DataProvider(
                    api: APIFixture(),
                    persister: AppearancesPersisterFixture()
                ).appearancesDataProvidingFixture(false)(Superhero.fixture().id)
            )
                .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255)),
            as: .image()
        )
    }
}
