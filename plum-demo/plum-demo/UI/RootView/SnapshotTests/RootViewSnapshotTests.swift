import SnapshotTesting
import XCTest
import SwiftUI
@testable import plum_demo

final class RootViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_loading() {
        let viewModel = RootViewModel(
            dataProvider: DataProvider(
                api: APIFixture(),
                persister: SuperheroPersisterFixture()
            ).superheroDataProvidingFixture(false)
        )

        viewModel.state.status = .loading

        let mySquadViewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: APIFixture(),
                persister: MySquadPersisterFixture()
            ).superheroDataProvidingFixture(false)
        )

        mySquadViewModel.state.status = .loading

        assertSnapshot(
            matching: RootView(
                viewModel: viewModel,
                mySquadViewModel: mySquadViewModel,
                mySquadMembers: [],
                superheroDestinationView: { _, _ in EmptyView() },
                mySquadDestinationView: { _, _ in EmptyView() }
            )
                .background(Colors.background),
            as: .image()
        )
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

        viewModel.state.status = .loaded
        viewModel.state.superheroes = superheroes

        let mySquadViewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: APIFixture(),
                persister: MySquadPersisterFixture()
            ).superheroDataProvidingFixture(false)
        )

        mySquadViewModel.state.status = .loaded
        mySquadViewModel.state.squad = superheroes

        assertSnapshot(
            matching: RootView(
                viewModel: viewModel,
                mySquadViewModel: mySquadViewModel,
                mySquadMembers: superheroes,
                superheroDestinationView: { _, _ in EmptyView() },
                mySquadDestinationView: { _, _ in EmptyView() }
            )
                .background(Colors.background),
            as: .image()
        )
    }
}
