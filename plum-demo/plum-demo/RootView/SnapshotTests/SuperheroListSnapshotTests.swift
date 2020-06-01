import SnapshotTesting
import XCTest
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
            matching: SuperheroList(superheroes: superheroes),
            as: .image()
        )
    }
}
