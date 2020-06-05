import Combine

// A protocol witness in place of the usual protocol
struct DataProviding<T: Codable, E: Error> {
    let fetch: (_ path: String) -> AnyPublisher<T, E>
    let persist: (T, _ path: String) -> AnyPublisher<Void, Never>
}

struct DataProvider {
    // Sadly `api` and `persister` cannot be made private because they
    // need to be accessible from the extensions (in different files).
    // I wish an `extensionprivate` existed.
    let api: API
    let persister: PersisterProtocol
}

enum DataProvidingError: Error {
    case error(Error)
}
