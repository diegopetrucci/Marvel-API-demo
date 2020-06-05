import XCTest
import SnapshotTesting
import struct SwiftUI.Color
@testable import plum_demo

final class AsyncImageViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    // TODO inject `state`s
    func test_idle() {
        let viewModel = AsyncImageViewModel(
            url: URL.fixture(),
            dataProvider: ImageProvider(
                api: APIFixture(),
                persister: ImagePersisterFixture()
            ).imageDataProviding(.fixture())
        )

        let view = AsyncImageView(viewModel: viewModel)

        assertSnapshot(matching: view, as: .image())
    }
}
