import Combine
import class UIKit.UIImage
import Foundation
import Then

final class AsyncImageViewModel: ObservableObject {
    @Published var state: State

    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event.UI, Never>()

    init(
        url: URL?,
        dataProvider: ImageProviding
    ) {
        self.state = State(
            status: .idle
        )

        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(url: url, dataProvider: dataProvider),
                Self.whenLoaded(url: url, dataProvider: dataProvider),
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
        case .ui(.onAppear), .ui(.onDisappear):
            // if we already have an image loaded we keep the loaded state,
            // otherwise we go back to .idle to give it another chance to load
            switch state.status {
            case .loaded, .persisted:
                return state
            case .idle, .loading, .failed:
                return state.with { $0.status = .loading }
            }
        case let .loaded(image):
            guard let image = image else { return state.with { $0.status = .failed(placeholder: Self.placeholder) } }

            return state.with { $0.status = .loaded(image: image) }
        case .failedToLoad:
            return state.with { $0.status = .failed(placeholder: Self.placeholder) }
        case let .persisted(image):
            guard let image = image else { return state.with { $0.status = .failed(placeholder: Self.placeholder) } }
            
            return state.with { $0.status = .persisted(image: image)}
        }
    }
}

extension AsyncImageViewModel {
    private static func whenLoading(
        url: URL?,
        dataProvider: ImageProviding
    ) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state.status else { return Empty().eraseToAnyPublisher() }

            guard let url = url else { return Just(Event.failedToLoad).eraseToAnyPublisher() }

            return dataProvider.fetch(url.absoluteString)
                .map(Event.loaded)
                .replaceError(with: .failedToLoad)
                .eraseToAnyPublisher()
        }
    }

    private static func whenLoaded(
        url: URL?,
        dataProvider: ImageProviding
    ) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case let .loaded(image) = state.status else { return Empty().eraseToAnyPublisher() }

            guard let url = url else { return Just(Event.failedToLoad).eraseToAnyPublisher() }

            return dataProvider.persist(image, url.absoluteString)
                .map { _ in Event.persisted(image) }
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
    }

    enum Status: Equatable {
        case idle
        case loading
        case loaded(image: UIImage)
        case failed(placeholder: UIImage)
        case persisted(image: UIImage)
    }

    enum Event {
        case ui(UI)
        case loaded(UIImage?)
        case failedToLoad
        case persisted(UIImage?)

        enum UI {
            case onAppear
            case onDisappear
        }
    }
}

extension AsyncImageViewModel {
    static var placeholder: UIImage {
        UIImage(named: "thumbnail_placeholder")!
    }
}
