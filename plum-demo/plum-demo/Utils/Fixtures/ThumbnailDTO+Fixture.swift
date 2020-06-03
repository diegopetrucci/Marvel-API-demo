@testable import plum_demo

extension ThumbnailDTO {
    static func fixture() -> Self {
        .init(
            path: "png",
            extension: "https://google.com/image"
        )
    }
}
