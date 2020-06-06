import Combine

extension DataProvider {
    var mySquadDataProviding: DataProviding<[Superhero], DataProvidingError> {
        DataProviding(
            fetch: { path -> AnyPublisher<[Superhero], DataProvidingError> in
                self.persister.fetch(type: [Superhero].self, path: path)
                    .mapError(DataProvidingError.error)
                    .eraseToAnyPublisher()
        }) { superheroes, path -> AnyPublisher<Void, Never> in
            self.persister.persist(t: superheroes, path: path)
                .map { _ in () }
                // It's a good question on what should happen when
                // the app fails to persist data. Maybe some corruption?
                // At the moment this is effectively unhandled.
                .replaceError(with: ())
                .eraseToAnyPublisher()
        }
    }
}

#if DEBUG
extension DataProvider {
    var mySquadDataProvidingFixture: (_ shouldErrorOut: Bool) -> DataProviding<[Superhero], DataProvidingError> {
        return { shouldErrorOut in
            DataProviding(
                fetch: { path -> AnyPublisher<[Superhero], DataProvidingError> in
                    let superheroes: [Superhero] = [.fixture(), .fixture(), .fixture()]
                    return Just(superheroes)
                        .setFailureType(to: DataProvidingError.self)
                        .eraseToAnyPublisher()
            }) { superheroes, path -> AnyPublisher<Void, Never> in
                Just(())
                    .replaceError(with: ())
                    .eraseToAnyPublisher()
            }
        }
    }
}
#endif
