import XCTest
import SnapshotTesting
@testable import plum_demo

final class HeroDetailViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_loaded() {
        let viewModel = HeroDetailViewModel(
            superhero: .fixture(),
            shouldPresentAlert: .constant(false),
            appearancesDataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()),
                persister: Persister()
            ).appearancesDataProvidingFixture(false)(3),
            mySquadDataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()),
                persister: Persister()
            ).mySquadDataProvidingFixture(false)
        )

        let apperances: [Appearance] = [.fixture(), .fixture(), .fixture()]

        viewModel.state = .init(
            superhero: .fixture(),
            appearances: apperances,
            squad: [.fixture(), .fixture(), .fixture()],
            alert: .init(superheroName: "Name", shouldPresent: .constant(false)),
            status: .loaded(appearances: apperances)
        )

        assertSnapshot(
            matching: HeroDetailView(
                viewModel: viewModel)
                .background(Colors.background),
            as: .image()
        )
    }
}
