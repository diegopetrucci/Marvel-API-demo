import XCTest
import SnapshotTesting
@testable import plum_demo

final class HeroDetailViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_idle() {
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

        viewModel.state = .init(
            superhero: .fixture(),
            appearances: [],
            squad: [.fixture(), .fixture(), .fixture()],
            alert: .init(superheroName: "Name", shouldPresent: .constant(false)),
            status: .idle
        )

        assertSnapshot(
            matching: HeroDetailView(
                viewModel: viewModel)
                .background(Colors.background),
            as: .image()
        )
    }

    func test_loading() {
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

        viewModel.state = .init(
            superhero: .fixture(),
            appearances: [],
            squad: [.fixture(), .fixture(), .fixture()],
            alert: .init(superheroName: "Name", shouldPresent: .constant(false)),
            status: .loading
        )

        assertSnapshot(
            matching: HeroDetailView(
                viewModel: viewModel)
                .background(Colors.background),
            as: .image()
        )
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
            status: .loaded
        )

        assertSnapshot(
            matching: HeroDetailView(
                viewModel: viewModel)
                .background(Colors.background),
            as: .image()
        )
    }

    func test_failed() {
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

        viewModel.state = .init(
            superhero: .fixture(),
            appearances: [],
            squad: [.fixture(), .fixture(), .fixture()],
            alert: .init(superheroName: "Name", shouldPresent: .constant(false)),
            status: .failed
        )

        assertSnapshot(
            matching: HeroDetailView(
                viewModel: viewModel)
                .background(Colors.background),
            as: .image()
        )
    }
}
