@testable import plum_demo

extension ThumbnailDTO {
    static func fixture() -> Self {
        .init(
            path: "http://google",
            extension: "com"
        )
    }
}
