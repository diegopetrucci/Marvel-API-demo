import class SwiftUI.UIImage

struct Appearance {
    let image: UIImage
    let title: String
}

#if DEBUG
extension Appearance {
    static func fixture() -> Self {
        .init(
            image: UIImage(named: "a_bomb_header")!,
            title: "Hulk (2008) #55"
        )
    }
}
#endif
