import SnapshotTesting
import XCTest
import SwiftUI
@testable import plum_demo

final class MySquadViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_default() {
        let viewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: APIFixture(),
                persister: MySquadPersisterFixture()
            ).superheroDataProvidingFixture(false)
        )

        viewModel.state.status = .loaded([
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture()
        ])

        assertSnapshot(
            matching: MySquadView(
                viewModel: viewModel,
                destinationView: { _, _ in EmptyView() }
            )
                .background(Colors.background)
                .frame(width: 500, height: 200),
            as: .image()
        )
    }
}
