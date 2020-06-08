import SnapshotTesting
import XCTest
import SwiftUI
@testable import plum_demo

final class SuperheroListSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_default() {
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

        assertSnapshot(
            matching: SuperheroList(
                superheroes: superheroes,
                mySquad: superheroes,
                destinationView: { _, _ in EmptyView() }
            )
                .background(Colors.background),
            as: .image()
        )
    }
}
