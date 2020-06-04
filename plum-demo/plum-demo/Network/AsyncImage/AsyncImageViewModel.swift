import Combine
import class UIKit.UIImage
import Foundation
import Then

final class AsyncImageViewModel: ObservableObject {
    @Published private(set) var state: State

    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event.UI, Never>()

    init(
        url: URL?,
        api: API
    ) {
        self.state = State(
            status: .idle
        )

        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(url: url, api: api),
                Self.userInput(input.eraseToAnyPublisher())
            ]
        )
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
}

extension AsyncImageViewModel {
    func send(event: Event.UI) {
        input.send(event)
    }
}

extension AsyncImageViewModel {
    private static func reduce(_ state: State, _ event: Event) -> State {
        switch event {
        case .ui(.onAppear):
            // if we already have an image loaded we keep the loaded state,
            // otherwise we go back to .idle to give it another chance to load
            if case .loaded = state.status {
                return state
            } else {
                return state.with { $0.status = .loading }
            }
        case .ui(.onDisappear):
            // if we already have an image loaded we keep the loaded state,
            // otherwise we go back to .idle to give it another chance to load
            if case .loaded = state.status {
                return state
            } else {
                return state.with { $0.status = .idle }
            }
        case let .loaded(image):
            guard let image = image else { return state.with { $0.status = .failed(placeholder: Self.placeholder) } }

            return state.with { $0.status = .loaded(image: image) }
        case .failedToLoad:
            return state.with { $0.status = .failed(placeholder: Self.placeholder) }
        }
    }
}

extension AsyncImageViewModel {
    private static func whenLoading(
        url: URL?,
        api: API
    ) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state.status else { return Empty().eraseToAnyPublisher() }

            guard let url = url else { return Just(Event.failedToLoad).eraseToAnyPublisher() }

            return api.image(for: url)
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

extension AsyncImageViewModel {
    struct State: Then {
        var status: Status

        // Note: workaround of SwiftUI views not supporting
        // if-lets or switches
        var image: UIImage {
            if case let .loaded(image) = status {
                return image
            } else {
                fatalError("This should never be called, the view is misconfigured.")
            }
        }
    }

    enum Status: Equatable {
        case idle
        case loading
        case loaded(image: UIImage)
        case failed(placeholder: UIImage)
    }

    enum Event {
        case ui(UI)
        case loaded(UIImage?)
        case failedToLoad

        enum UI {
            case onAppear
            case onDisappear
        }
    }
}

// TODO remove?
extension AsyncImageViewModel {
    static var placeholder: UIImage {
        UIImage(named: "superhero_stub")!
    }
}

#if DEBUG
extension AsyncImageViewModel {
    static func fixture() -> AsyncImageViewModel {
        AsyncImageViewModel.init(
            url: .fixture(),
            api: MarvelAPI(remote: Remote()) // TODO fixture
        )
    }
}
#endif
