import struct Foundation.URL

struct ComicDTO {
    let id: Int
    let title: String
    let thumbnail: ThumbnailDTO
}

extension ComicDTO: Equatable, Decodable {}
