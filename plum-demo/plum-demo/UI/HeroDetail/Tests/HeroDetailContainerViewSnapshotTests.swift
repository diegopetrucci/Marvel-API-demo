import XCTest
import SnapshotTesting
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
                mySquad: [.fixture(), .fixture(), .fixture()],
                appearancesDataProvider: DataProvider(
                    api: APIFixture(),
                    persister: AppearancesPersisterFixture()
                ).appearancesDataProvidingFixture(false)(3)
            )
                .background(Colors.background),
            as: .image()
        )
    }
}
