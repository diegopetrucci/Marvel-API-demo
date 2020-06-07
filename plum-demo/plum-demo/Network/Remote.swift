import Foundation
import Combine
import class UIKit.UIImage

protocol RemoteProtocol {
    func load<T: Decodable>(from request: URLRequest, jsonDecoder: JSONDecoder) -> AnyPublisher<T, RemoteError>
    func loadData(from imageURL: URL) -> AnyPublisher<Data, RemoteError>
}

struct Remote: RemoteProtocol {
    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func load<T: Decodable>(
        from request: URLRequest,
        jsonDecoder: JSONDecoder
    ) -> AnyPublisher<T, RemoteError> {
        urlSession.dataTaskPublisher(for: request)
            .mapError { RemoteError.error($0.localizedDescription) }
            .tryMap(validStatusCode)
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError { RemoteError.error($0.localizedDescription) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func loadData(from imageURL: URL) -> AnyPublisher<Data, RemoteError> {
        urlSession.dataTaskPublisher(for: URLRequest(url: imageURL))
            .mapError { RemoteError.error($0.localizedDescription) }
            .tryMap(validStatusCode)
            .mapError { ($0 as? RemoteError) ?? .unknown }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension Remote {
    private func validStatusCode(data: Data, response: URLResponse) throws -> Data {
        guard
            let statusCode = (response as? HTTPURLResponse)?.statusCode
        else { throw RemoteError.unknown }

        guard
            statusCode >= 200,
            statusCode < 300
        else { throw RemoteError.statusCode(statusCode) }

        return data
    }
}

enum RemoteError: Error {
    case error(String)
    case statusCode(Int)
    case unknown
    case parsingError(String)
}

extension RemoteError: Equatable {}
