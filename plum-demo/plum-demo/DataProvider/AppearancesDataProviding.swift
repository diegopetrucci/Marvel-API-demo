import Combine

extension DataProvider {
    // `appearancesDataProviding` needs to be a function that returns a `DataProviding`
    // instead of directly returning it because the API call needs one more information,
    // the `characterID`. To avoid polluting `DataProviding`'s API with parameters
    // that only some clients might use `appearancesDataProviding` now explicitly requires the id.
    var appearancesDataProviding: (_ characterID: Int) -> DataProviding<[Appearance], DataProvidingError> {
        return { id in
            DataProviding(
                fetch: { path -> AnyPublisher<[Appearance], DataProvidingError> in
                    let persisterPublisher = self.persister.fetch(type: [Appearance].self, path: path)
                        .mapError(DataProvidingError.error)
                        .eraseToAnyPublisher()

                    return self.api.comics(for: id)
                        .map { comics -> [Appearance] in
                            return comics.map { comic in
                                Appearance(
                                    imageURL: comic.thumbnail.url,
                                    title: comic.title
                                )
                            }
                    }
                    .catch { _ in persisterPublisher }
                    .eraseToAnyPublisher()
            }) { appearances, path -> AnyPublisher<Void, Never> in
                self.persister.persist(t: appearances, path: path)
                    .map { _ in () }
                    // It's a good question on what should happen when
                    // the app fails to persist data. Maybe some corruption?
                    // At the moment this is effectively unhandled.
                    .replaceError(with: ())
                    .eraseToAnyPublisher()
            }
        }
    }
}

#if DEBUG
extension DataProvider {
    var appearancesDataProvidingFixture: (_ shouldErrorOut: Bool) -> (_ id: Int) -> DataProviding<[Appearance], DataProvidingError> {
        return { shouldErrorOut in
            return { id in
                DataProviding(
                    fetch: { path -> AnyPublisher<[Appearance], DataProvidingError> in
                        let appearances: [Appearance] = [.fixture(), .fixture(), .fixture()]
                        return Just(appearances)
                            .setFailureType(to: DataProvidingError.self)
                            .eraseToAnyPublisher()
                }) { appearances, path -> AnyPublisher<Void, Never> in
                    Just(())
                        .replaceError(with: ())
                        .eraseToAnyPublisher()
                }
            }
        }
    }
}
#endif
