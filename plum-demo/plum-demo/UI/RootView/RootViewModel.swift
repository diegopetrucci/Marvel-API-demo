import Combine
import Foundation
import Then

final class RootViewModel: ObservableObject {
    @Published var state: State

    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event.UI, Never>()

    init(dataProvider: DataProviding<[Superhero], DataProvidingError>) {
        self.state = State(
            status: .idle,
            superheroes: []
        )

        let path = "/superheroes"

        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(path: path, dataProvider: dataProvider),
                Self.whenLoaded(path: path, dataProvider: dataProvider),
                Self.userInput(input.eraseToAnyPublisher())
            ]
        )
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
}

extension RootViewModel {
    func send(event: Event.UI) {
        input.send(event)
    }
}

extension RootViewModel {
    private static func reduce(_ state: State, _ event: Event) -> State {
        switch event {
        case .ui(.onAppear), .ui(.onDisappear):
            // If we already have an superheroes we keep the loaded state,
            // otherwise we go back to .idle to give it another chance to load.
            // Note: this would probably have to change when pagination is implemented
            switch state.status {
            case .loaded:
                return state
            case .idle, .loading, .failed:
                return state.with { $0.status = .loading }
            }
        case .ui(.retry):
                return state.with { $0.status = .loading }
        case let .loaded(superheroes):
            return state.with {
                $0.status = .loaded
                $0.superheroes = superheroes
            }
        case .failedToLoad:
            return state.with { $0.status = .failed }
        case .persisted:
            return state.with {
                $0.status = .loaded
                $0.hasPersisted = true
            }
        }
    }
}

extension RootViewModel {
    private static func whenLoading(
        path: String,
        dataProvider: DataProviding<[Superhero], DataProvidingError>
    ) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state.status else { return Empty().eraseToAnyPublisher() }

            return dataProvider.fetch(path)
                .map(Event.loaded)
                .replaceError(with: .failedToLoad)
                .eraseToAnyPublisher()
        }
    }

    private static func whenLoaded(
        path: String,
        dataProvider: DataProviding<[Superhero], DataProvidingError>
    ) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard
                case .loaded = state.status,
                state.hasPersisted.isFalse
            else { return Empty().eraseToAnyPublisher() }

            return dataProvider.persist(state.superheroes, path)
                .map { _ in Event.persisted }
                .replaceError(with: .failedToLoad)
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

extension RootViewModel {
    struct State: Then {
        var status: Status
        var superheroes: [Superhero]
        var hasPersisted: Bool = false
    }

    enum Status: Equatable {
        case idle
        case loading
        case loaded
        case failed
    }

    enum Event {
        case ui(UI)
        case loaded([Superhero])
        case failedToLoad
        case persisted

        enum UI {
            case onAppear
            case onDisappear
            case retry
        }
    }
}
