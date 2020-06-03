struct CharacterResponse {
    let data: Data
}

extension CharacterResponse: Equatable, Decodable {}

extension CharacterResponse {
    struct Data {
        let results: [CharacterDTO]
    }
}

extension CharacterResponse.Data: Equatable, Decodable {}
