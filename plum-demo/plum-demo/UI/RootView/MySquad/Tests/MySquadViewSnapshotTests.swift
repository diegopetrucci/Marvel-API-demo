import SnapshotTesting
import XCTest
import SwiftUI
@testable import plum_demo

final class MySquadViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_idle() {
        let viewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: APIFixture(),
                persister: MySquadPersisterFixture()
            ).superheroDataProvidingFixture(false)
        )

        viewModel.state.status = .idle

        assertSnapshot(
            matching: MySquadView(
                viewModel: viewModel,
                destinationView: { _, _ in EmptyView() },
                asyncImageView: { _, _, _ in .fixture() }
            )
                .background(Colors.background)
                .frame(width: 500, height: 200),
            as: .image()
        )
    }

    func test_loading() {
        let viewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: APIFixture(),
                persister: MySquadPersisterFixture()
            ).superheroDataProvidingFixture(false)
        )

        viewModel.state.status = .loading

        assertSnapshot(
            matching: MySquadView(
                viewModel: viewModel,
                destinationView: { _, _ in EmptyView() },
                asyncImageView: { _, _, _ in .fixture() }
            )
                .background(Colors.background)
                .frame(width: 500, height: 200),
            as: .image()
        )
    }

    func test_loaded() {
        let viewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: APIFixture(),
                persister: MySquadPersisterFixture()
            ).superheroDataProvidingFixture(false)
        )

        viewModel.state.status = .loaded
        viewModel.state.squad = [
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture()
        ]

        assertSnapshot(
            matching: MySquadView(
                viewModel: viewModel,
                destinationView: { _, _ in EmptyView() },
                asyncImageView: { _, _, _ in .fixture() }
            )
                .background(Colors.background)
                .frame(width: 500, height: 200),
            as: .image()
        )
    }

    func test_failed() {
        let viewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: APIFixture(),
                persister: MySquadPersisterFixture()
            ).superheroDataProvidingFixture(false)
        )

        viewModel.state.status = .failed

        assertSnapshot(
            matching: MySquadView(
                viewModel: viewModel,
                destinationView: { _, _ in EmptyView() },
                asyncImageView: { _, _, _ in .fixture() }
            )
                .background(Colors.background)
                .frame(width: 500, height: 200),
            as: .image()
        )
    }
}
