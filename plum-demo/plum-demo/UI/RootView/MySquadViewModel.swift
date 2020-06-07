import Combine
import class UIKit.UIImage
import Foundation
import Then

final class MySquadViewModel: ObservableObject {
    @Published var state: State

    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event.UI, Never>()

    init(dataProvider: DataProviding<[Superhero], DataProvidingError>) {
        self.state = State(status: .idle)

        let path = "/mysquad"

        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(path: path, dataProvider: dataProvider),
                Self.userInput(input.eraseToAnyPublisher())
            ]
        )
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
}

extension MySquadViewModel {
    func send(event: Event.UI) {
        input.send(event)
    }
}

extension MySquadViewModel {
    private static func reduce(_ state: State, _ event: Event) -> State {
        switch event {
        case .ui(.onAppear), .ui(.onDisappear):
            return state.with { $0.status = .loading }
        case let .loaded(superheroes):
            return state.with { $0.status = .loaded(superheroes) }
        case .failedToLoad:
            return state.with { $0.status = .failed }
        }
    }
}

extension MySquadViewModel {
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

    private static func userInput(_ input: AnyPublisher<Event.UI, Never>) -> Feedback<State, Event> {
        Feedback(run: { _ in
            input
                .map(Event.ui)
                .eraseToAnyPublisher()
        })
    }
}

extension MySquadViewModel {
    struct State: Then {
        var status: Status
    }

    enum Status: Equatable {
        case idle
        case loading
        case loaded([Superhero])
        case failed
    }

    enum Event {
        case ui(UI)
        case loaded([Superhero])
        case failedToLoad

        enum UI {
            case onAppear
            case onDisappear
        }
    }
}
