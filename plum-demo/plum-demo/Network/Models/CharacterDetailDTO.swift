// TODO
struct CharacterDetailDTO: Equatable, Decodable {}
#if DEBUG
extension CharacterDetailDTO { static func fixture() -> Self { .init() } }
#endif
