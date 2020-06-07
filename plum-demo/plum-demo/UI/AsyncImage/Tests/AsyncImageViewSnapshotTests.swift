import XCTest
import SnapshotTesting
@testable import plum_demo

final class AsyncImageViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()

        record = false
    }

    func test_idle() {
        let viewModel = AsyncImageViewModel(
            url: URL.fixture(),
            dataProvider: ImageProvider(
                api: APIFixture(),
                persister: ImagePersisterFixture()
            ).imageDataProviding(.fixture())
        )

        viewModel.state = .init(status: .idle)

        let view = AsyncImageView(viewModel: viewModel)

        assertSnapshot(matching: view, as: .image())
    }

    func test_loading() {
        let viewModel = AsyncImageViewModel(
            url: URL.fixture(),
            dataProvider: ImageProvider(
                api: APIFixture(),
                persister: ImagePersisterFixture()
            ).imageDataProviding(.fixture())
        )

        viewModel.state = .init(status: .loading)

        let view = AsyncImageView(viewModel: viewModel)

        assertSnapshot(matching: view, as: .image())
    }

    func test_loaded() {
        let viewModel = AsyncImageViewModel(
            url: URL.fixture(),
            dataProvider: ImageProvider(
                api: APIFixture(),
                persister: ImagePersisterFixture()
            ).imageDataProviding(.fixture())
        )

        viewModel.state = .init(status: .loaded(image: .fixture()))

        let view = AsyncImageView(viewModel: viewModel)

        assertSnapshot(matching: view, as: .image())
    }

    func test_persisted() {
        let viewModel = AsyncImageViewModel(
            url: URL.fixture(),
            dataProvider: ImageProvider(
                api: APIFixture(),
                persister: ImagePersisterFixture()
            ).imageDataProviding(.fixture())
        )

        viewModel.state = .init(status: .persisted(image: .fixture()))

        let view = AsyncImageView(viewModel: viewModel)

        assertSnapshot(matching: view, as: .image())
    }

    func test_failed() {
        let viewModel = AsyncImageViewModel(
            url: URL.fixture(),
            dataProvider: ImageProvider(
                api: APIFixture(),
                persister: ImagePersisterFixture()
            ).imageDataProviding(.fixture())
        )

        viewModel.state = .init(status: .failed(placeholder: .fixture()))

        let view = AsyncImageView(viewModel: viewModel)

        assertSnapshot(matching: view, as: .image())
    }
}
