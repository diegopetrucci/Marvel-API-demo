struct ThumbnailDTO {
    let path: String
    let `extension`: String

    var fullPath: String { "\(path).\(`extension`)" }
}

extension ThumbnailDTO: Equatable, Decodable {}
