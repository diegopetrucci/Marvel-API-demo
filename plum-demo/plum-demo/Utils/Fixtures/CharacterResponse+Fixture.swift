@testable import plum_demo

extension CharacterResponse {
    static func fixture() -> Self {
        .init(data: .fixture())
    }
}

extension CharacterResponse.Data {
    static func fixture() -> Self {
        .init(results: [.fixture(), .fixture(), .fixture()])
    }
}
