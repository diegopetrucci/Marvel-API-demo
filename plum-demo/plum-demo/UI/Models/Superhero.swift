import class SwiftUI.UIImage
import struct Foundation.URL

struct Superhero {
    let id: Int
    let imageURL: URL?
    let name: String
    let description: String
}

extension Superhero: Hashable {}

#if DEBUG
extension Superhero {
    static func fixture() -> Self {
        .init(
            id: 3,
            imageURL: .fixture(),
            name: "DC Superman",
            description: "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction!"
        )
    }
}
#endif
