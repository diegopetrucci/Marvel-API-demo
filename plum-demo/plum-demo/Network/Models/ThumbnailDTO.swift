import struct Foundation.URL

struct ThumbnailDTO {
    let path: String
    let `extension`: String

    var fullPath: String { "\(path).\(`extension`)" }
}

// I am not completely sure if this is breaking
// the DTO contract. Maybe a better version of this
// would be creating a wrapper type.
extension ThumbnailDTO {
    var url: URL? { URL(string: path + "." + `extension`) }
}

extension ThumbnailDTO: Equatable, Decodable {}
