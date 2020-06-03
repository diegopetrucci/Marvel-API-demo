import Combine
import Foundation
import CryptoSwift
import class SwiftUI.UIImage

// A note regarding all the force unwrapping here:
// This is information that is known a priori and should not change,
// as such I think it's safe to force-unwrapp when constructing URLs.
// It might be argued that it could be useful to `fatalError` with a
// description, but IMO everything here is sufficiently self-explanatory.
// At the end of the day a crash here would mean a breach
// of the contract, not a logic error.

protocol API {
    func characters() -> AnyPublisher<[CharacterDTO], APIError>
    func characterDetail(for characterID: Int) -> AnyPublisher<CharacterDetailDTO, APIError>
    func image(for url: URL) -> AnyPublisher<UIImage?, Never> // TODO should it be optional?
}

struct MarvelAPI: API {
    private let remote: RemoteProtocol
    private let jsonDecoder: JSONDecoder

    init(remote: RemoteProtocol, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.remote = remote
        self.jsonDecoder = jsonDecoder
    }

    func characters() -> AnyPublisher<[CharacterDTO], APIError> {
        let responsePublisher: AnyPublisher<CharacterResponse, RemoteError> = remote.load(
            from: URLRequest(url: url(forPath: "characters")),
            jsonDecoder: jsonDecoder
        )

        return responsePublisher
            .map { $0.data.results }
            .mapError(APIError.remote)
            .eraseToAnyPublisher()
    }

    func characterDetail(for characterID: Int) -> AnyPublisher<CharacterDetailDTO, APIError> {
        remote.load(from: URLRequest(url: url(forPath: "characters/\(characterID)")), jsonDecoder: jsonDecoder)
            .mapError(APIError.remote)
            .eraseToAnyPublisher()
    }

    func image(for url: URL) -> AnyPublisher<UIImage?, Never> {
        remote.loadData(from: url)
            .map(UIImage.init)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

extension MarvelAPI {
    // TODO should this be tested?
    private func url(forPath path: String) -> URL {
        let publicKey = "9f7401a37030ff8f9733156fa55b5155"
        let privateKey = "de78daf2480c1a2aed929863b3d81a4a7023bdde"
        let baseURL = URL(string: "https://gateway.marvel.com/v1/public/")!

        let url = URL(string: path, relativeTo: baseURL)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!

        let timestamp = "\(Date().timeIntervalSince1970)"
        let queryItems: [URLQueryItem] = [
            .init(name: "ts", value: timestamp),
            .init(name: "apikey", value: publicKey),
            .init(name: "hash", value: (timestamp + privateKey + publicKey).md5())
        ]

        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }
}

enum APIError: Error {
    case remote(RemoteError)
}

extension APIError: Equatable {}
