import Foundation
import Combine
import class UIKit.UIImage

protocol RemoteProtocol {
    func load<T: Decodable>(from url: URL, jsonDecoder: JSONDecoder) -> AnyPublisher<T, RemoteError>
    func loadData(from imageURL: URL) -> AnyPublisher<Data, RemoteError>
}

struct Remote: RemoteProtocol {
    func load<T: Decodable>(
        from url: URL,
        jsonDecoder: JSONDecoder // TODO add back = JSONDecoder()
    ) -> AnyPublisher<T, RemoteError> {
        URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { RemoteError.error($0.localizedDescription) }
            .tryMap(validStatusCode)
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError { RemoteError.error($0.localizedDescription) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func loadData(from imageURL: URL) -> AnyPublisher<Data, RemoteError> {
        URLSession.shared.dataTaskPublisher(for: URLRequest(url: imageURL))
            .mapError { RemoteError.error($0.localizedDescription) }
            .tryMap(validStatusCode)
            .mapError { ($0 as? RemoteError) ?? .unknown } // TODO what is this error
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
    case error(String) // TODO: make this case and `unknown` the same
    case statusCode(Int)
    case unknown
    case parsingError(String)
}

extension RemoteError: Equatable {}
