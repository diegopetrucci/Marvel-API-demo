// TODO
struct CharacterDetail: Equatable, Decodable {}
#if DEBUG
extension CharacterDetail { static func fixture() -> Self { .init() } }
#endif
