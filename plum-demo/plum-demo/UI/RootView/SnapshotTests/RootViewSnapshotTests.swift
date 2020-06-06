import SnapshotTesting
import XCTest
import struct SwiftUI.Color
@testable import plum_demo

final class RootViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_loaded() {
        let superheroes: [Superhero] = [
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture()
        ]

        let viewModel = RootViewModel(
            dataProvider: DataProvider(
                api: APIFixture(),
                persister: SuperheroPersisterFixture()
            ).superheroDataProvidingFixture(false)
        )

        viewModel.state.status = .loaded(superheroes)

        let mySquadViewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: APIFixture(),
                persister: MySquadPersisterFixture()
            ).superheroDataProvidingFixture(false)
        )

        mySquadViewModel.state.status = .loaded(superheroes)

        assertSnapshot(
            matching: RootView(
                viewModel: viewModel,
                mySquadViewModel: mySquadViewModel,
                mySquadMembers: superheroes
            )
                .background(Colors.background),
            as: .image()
        )
    }
}
