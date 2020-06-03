struct CharacterDTO {
    let id: Int
    let name: String
    let description: String
    let thumbnail: ThumbnailDTO
}

extension CharacterDTO: Equatable, Decodable {}
