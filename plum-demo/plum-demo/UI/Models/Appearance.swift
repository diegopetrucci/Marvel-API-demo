import class SwiftUI.UIImage
import struct Foundation.URL

struct Appearance {
    let imageURL: URL?
    let title: String
}

extension Appearance: Equatable, Hashable, Codable {}

#if DEBUG
extension Appearance {
    static func fixture() -> Self {
        .init(
            imageURL: .fixture(),
            title: "Hulk (2008) #55"
        )
    }
}
#endif
