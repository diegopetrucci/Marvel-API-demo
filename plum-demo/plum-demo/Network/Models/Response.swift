struct Response<T: Decodable & Equatable> {
    let data: Data
}

extension Response: Equatable, Decodable {}

extension Response {
    struct Data {
        let results: [T]
    }
}

extension Response.Data: Equatable, Decodable {}
