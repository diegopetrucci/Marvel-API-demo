import XCTest
import SnapshotTesting
@testable import plum_demo

final class AsyncImageViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_loaded() {
        let provider = ImageProvider(
            api: APIFixture(),
            persister: ImagePersisterFixture()
        )
            .imageDataProvidingFixture(false)(.fixture())
            .fetch("")
            .ignoreError()

        let view = AsyncImageView(
            sourcePublisher: provider,
            placeholder: UIImage(named: "thumbnail_fixture")!
        )

        assertSnapshot(matching: view, as: .image())
    }
}
