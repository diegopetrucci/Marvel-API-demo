import class SwiftUI.UIImage

struct Superhero {
    let image: UIImage
    let name: String
}

extension Superhero: Hashable {}

#if DEBUG
extension Superhero {
    static func fixture() -> Self {
        .init(
            image: UIImage(named: "superhero_stub")!,
            name: "DC Superman"
        )
    }
}
#endif
