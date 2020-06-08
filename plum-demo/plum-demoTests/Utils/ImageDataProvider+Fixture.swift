import class SwiftUI.UIImage
import Combine
@testable import plum_demo

extension ImageProvider {
    static func asyncImageViewSourceFixture() -> AnyPublisher<UIImage, Never> {
        ImageProvider(
            api: APIFixture(),
            persister: ImagePersisterFixture()
        )
            .imageDataProvidingFixture(false)(.fixture())
            .fetch("")
            .ignoreError()
    }
}
