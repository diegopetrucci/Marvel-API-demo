// TODO
struct Character: Equatable, Decodable {}
#if DEBUG
extension Character { static func fixture() -> Self { .init() } }
#endif
