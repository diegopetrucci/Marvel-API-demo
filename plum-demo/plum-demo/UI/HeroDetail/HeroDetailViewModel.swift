import Combine
import class UIKit.UIImage
import Foundation
import Then

final class HeroDetailViewModel: ObservableObject {
    @Published var state: State

    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event.UI, Never>()

    init(
        superhero: Superhero,
        appearancesDataProvider: DataProviding<[Appearance], DataProvidingError>,
        mySquadDataProvider: DataProviding<[Superhero], DataProvidingError>
    ) {
        self.state = State(
            superhero: superhero,
            appearances: [],
            squad: [],
            status: .idle
        )

        let appearancesPath = "\(superhero.id)" + "/appearances"
        let mySquadPath = "/mysquad"

        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(
                    apperancesPath: appearancesPath,
                    mySquadPath: mySquadPath,
                    apperancesDataProvider: appearancesDataProvider,
                    mySquadDataProvider: mySquadDataProvider
                ),
                Self.whenLoaded(path: appearancesPath, dataProvider: appearancesDataProvider),
                Self.whenEditingSquad(mySquadPath: mySquadPath, dataProvider: mySquadDataProvider),
                Self.userInput(input.eraseToAnyPublisher())
            ]
        )
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
}

extension HeroDetailViewModel {
    func send(event: Event.UI) {
        input.send(event)
    }
}

extension HeroDetailViewModel {
    private static func reduce(_ state: State, _ event: Event) -> State {
        switch event {
        case .ui(.onAppear):
            return state.with { $0.status = .loading } // TODO not repeat
        case .ui(.onDisappear):
            return state
        case .ui(.onSquadButtonPress):
            return state.with { $0.status = .editingSquad }
        case let .loaded(appearances, squad):
            guard appearances.count > 0 else { // TODO
                return state.with {
                    $0.status = .failed
                    $0.appearances = appearances
                    $0.squad = squad
                }
            }

            return state.with {
                $0.status = .loaded(appearances: appearances)
                $0.appearances = appearances
                $0.squad = squad
            }
        case .failedToLoad:
            return state.with {
                $0.status = .failed
                $0.appearances = []
            }
        case let .persistedAppearances(appearances):
             guard appearances.count > 0 else {
                return state.with {
                    $0.status = .failed
                    $0.appearances = appearances
                }
             }

            return state.with {
                $0.status = .persisted(appearances: appearances)
                $0.appearances = appearances
            }
        case let .persistedSquad(newSquad):
            return state.with {
                $0.squad = newSquad
                $0.status = .loaded(appearances: state.appearances) //TODO?
            }
        }
    }
}

extension HeroDetailViewModel {
    private static func whenLoading(
        apperancesPath: String,
        mySquadPath: String,
        apperancesDataProvider: DataProviding<[Appearance], DataProvidingError>,
        mySquadDataProvider: DataProviding<[Superhero], DataProvidingError>
    ) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state.status else { return Empty().eraseToAnyPublisher() }

            let apperancesPublisher = apperancesDataProvider.fetch(apperancesPath)

            let tuplePublisher = mySquadDataProvider.fetch(mySquadPath)
                .flatMap { squad -> AnyPublisher<([Appearance], [Superhero]), DataProvidingError> in
                    apperancesPublisher
                        .map { appearances in (appearances, squad) }
                        .eraseToAnyPublisher()
            }
            .catch { _ -> AnyPublisher<([Appearance], [Superhero]), DataProvidingError> in
                apperancesPublisher
                    .map { appearances in (appearances, []) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

            return tuplePublisher
                .map(Event.loaded)
                .replaceError(with: .failedToLoad)
                .eraseToAnyPublisher()
        }
    }

    private static func whenLoaded(
        path: String, // TODO rename appearances path
        dataProvider: DataProviding<[Appearance], DataProvidingError>
    ) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case let .loaded(appearances) = state.status else { return Empty().eraseToAnyPublisher() }

            return dataProvider.persist(appearances, path)
                .map { _ in Event.persistedAppearances(appearances) }
                .replaceError(with: .failedToLoad)
                .eraseToAnyPublisher()
        }
    }

    private static func whenEditingSquad(
        mySquadPath: String,
        dataProvider: DataProviding<[Superhero], DataProvidingError>
    ) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .editingSquad = state.status else { return Empty().eraseToAnyPublisher() }

            let newSquad: [Superhero]
            if state.squad.contains(state.superhero) {
                // TODO This would be better suited by a Set
                if let index = state.squad.firstIndex(of: state.superhero) {
                    var stateSquadCopy = state.squad
                    stateSquadCopy.remove(at: index)
                    newSquad = stateSquadCopy
                } else {
                    newSquad = state.squad
                }
            } else {
                newSquad = state.squad + [state.superhero]
            }

            return dataProvider.persist(newSquad, mySquadPath)
                .map { _ in Event.persistedSquad(newSquad) }
                .replaceError(with: .failedToLoad) // TODO
                .eraseToAnyPublisher()
        }
    }

    private static func userInput(_ input: AnyPublisher<Event.UI, Never>) -> Feedback<State, Event> {
        Feedback(run: { _ in
            input
                .map(Event.ui)
                .eraseToAnyPublisher()
        })
    }
}

extension HeroDetailViewModel {
    struct State: Then {
        let superhero: Superhero
        var appearances: [Appearance]
        var squad: [Superhero]
        var isPartOfSquad: Bool { squad.contains(superhero) }
        var status: Status
    }

    enum Status: Equatable {
        case idle
        case loading
        case loaded(appearances: [Appearance])
        case failed
        case persisted(appearances: [Appearance])
        case editingSquad
    }

    enum Event {
        case ui(UI)
        case loaded([Appearance], squad: [Superhero])
        case failedToLoad
        case persistedAppearances([Appearance])
        case persistedSquad([Superhero])

        enum UI {
            case onSquadButtonPress
            case onAppear
            case onDisappear
        }
    }
}

#if DEBUG
extension HeroDetailViewModel {
    static func fixture() -> HeroDetailViewModel {
        HeroDetailViewModel(
            superhero: .fixture(),
            appearancesDataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()), // TODO fixture
                persister: Persister() // TODO fixture
            ).appearancesDataProvidingFixture(false)(3),
            mySquadDataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()), // TODO fixture
                persister: Persister() // TODO fixture
            ).mySquadDataProvidingFixture(false)
        )
    }
}
#endif
