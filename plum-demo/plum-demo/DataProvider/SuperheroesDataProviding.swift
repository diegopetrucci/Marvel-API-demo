import Combine

extension DataProvider {
    var superheroDataProviding: DataProviding<[Superhero], DataProvidingError> {
        DataProviding(
            fetch: { path -> AnyPublisher<[Superhero], DataProvidingError> in
                let persisterPublisher = self.persister.fetch(type: [Superhero].self, path: path)
                    .mapError(DataProvidingError.error)
                    .eraseToAnyPublisher()

                return self.api.characters()
                    .map { characters -> [Superhero] in
                        return characters.map { character in
                            Superhero(
                                id: character.id,
                                imageURL: character.thumbnail.url,
                                name: character.name,
                                description: character.description
                            )
                        }
                }
                .catch { _ in persisterPublisher }
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
    var superheroDataProvidingFixture: (_ shouldErrorOut: Bool) -> DataProviding<[Superhero], DataProvidingError> {
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
