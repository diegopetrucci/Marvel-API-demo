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

        assertSnapshot(
            matching: RootView(
                superheroes: superheroes,
                mySquadMembers: superheroes,
                backgroundColor: Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255)
            ),
            as: .image()
        )
    }
}
