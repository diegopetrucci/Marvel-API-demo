import class SwiftUI.UIImage
import Combine

#if DEBUG
extension AsyncImageView {
    static func fixture() -> Self {
        AsyncImageView(
            source: ImageProvider(
                api: MarvelAPI(remote: Remote()),
                persister: ImagePersister()
            )
                .imageDataProvidingFixture(false)(.fixture())
                .fetch("")
                .ignoreError(),
            placeholder: UIImage(named: "thumbnail_fixture")!
        )

    }
}
#endif
