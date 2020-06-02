import SnapshotTesting
import XCTest
import struct SwiftUI.Color
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
                cellBackgroundColor: Color(red: 54 / 255, green: 59 / 255, blue: 69 / 255)
            ),
            as: .image()
        )
    }
}
