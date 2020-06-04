@testable import plum_demo

extension ComicDTO {
    static func fixture() -> Self {
        .init(
            id: 1,
            title: "Hulk (2008) #55",
            thumbnail: .fixture()
        )
    }
}
