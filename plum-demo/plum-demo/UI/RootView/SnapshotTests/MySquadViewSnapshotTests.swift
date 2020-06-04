import SnapshotTesting
import XCTest
import struct SwiftUI.Color
@testable import plum_demo

final class MySquadViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_default() {
        let members: [Superhero] = [
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
            matching: MySquadView(members: members)
                .background(Color(red: 54 / 255, green: 59 / 255, blue: 69 / 255))
                .frame(width: 500, height: 200),
            as: .image()
        )
    }
}
