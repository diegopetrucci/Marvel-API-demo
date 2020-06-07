import Combine
import class UIKit.UIImage
import Foundation
import Then
import struct SwiftUI.Binding

final class HeroDetailViewModel: ObservableObject {
    @Published var state: State

    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event.UI, Never>()

    init(
        superhero: Superhero,
        shouldPresentAlert: Binding<Bool>,
        appearancesDataProvider: DataProviding<[Appearance], DataProvidingError>,
        mySquadDataProvider: DataProviding<[Superhero], DataProvidingError>
    ) {
        self.state = State(
            superhero: superhero,
            appearances: [],
            squad: [],
            alert: .init(
                superheroName: superhero.name,
                shouldPresent: shouldPresentAlert
            ),
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
                Self.whenLoaded(
                    apperancesPath: appearancesPath,
                    dataProvider: appearancesDataProvider
                ),
                Self.whenEditingSquad(
                    mySquadPath: mySquadPath,
                    shouldPresentAlert: shouldPresentAlert,
                    dataProvider: mySquadDataProvider
                ),
                // Uncomment to test out the Alert
//                Self.whenRemovingFromSquad(
//                    mySquadPath: mySquadPath,
//                    dataProvider: mySquadDataProvider
//                ),
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
            // If we already have an superheroes we keep the loaded state,
            // otherwise we go back to .idle to give it another chance to load.
            // Note: this would probably have to change when pagination is implemented
            switch state.status {
            case .loaded:
                return state
            case .idle, .loading, .failed, .editingSquad:
                return state.with { $0.status = .loading }
            // Uncomment to test out the Alert
//            case .removingFromSquad:
//                 return state.with { $0.status = .loading }
            }
        case .ui(.onDisappear):
            return state
        case .ui(.onSquadButtonPress):
            return state.with { $0.status = .editingSquad }
        case let .loaded(appearances, squad):
            guard appearances.isNotEmpty else {
                return state.with {
                    $0.status = .failed
                    $0.appearances = appearances
                    $0.squad = squad
                }
            }

            return state.with {
                $0.status = .loaded
                $0.appearances = appearances
                $0.squad = squad
            }
        case .failedToLoad:
            return state.with {
                $0.status = .failed
                $0.appearances = []
            }
        case .persistedAppearances:
            guard state.appearances.isNotEmpty else {
                return state.with {
                    $0.status = .failed
                    $0.appearances = []
                }
             }

             return state.with { $0.status = .loading }
        case .persistedSquad:
            return state.with { $0.status = .loaded }
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
        apperancesPath: String,
        dataProvider: DataProviding<[Appearance], DataProvidingError>
    ) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard
                case .loaded = state.status,
                state.appearances.isNotEmpty
            else { return Empty().eraseToAnyPublisher() }

            return dataProvider.persist(state.appearances, apperancesPath)
                .map { _ in Event.persistedAppearances }
                .replaceError(with: .failedToLoad)
                .eraseToAnyPublisher()
        }
    }

    private static func whenEditingSquad(
        mySquadPath: String,
        shouldPresentAlert: Binding<Bool>,
        dataProvider: DataProviding<[Superhero], DataProvidingError>
    ) -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .editingSquad = state.status else { return Empty().eraseToAnyPublisher() }

            let newSquad: [Superhero]
            if state.squad.contains(state.superhero) {
                // This would be better suited by a Set IMO
                if let index = state.squad.firstIndex(of: state.superhero) {
                    var stateSquadCopy = state.squad
                    stateSquadCopy.remove(at: index)
                    newSquad = stateSquadCopy

                    // The commented out code enables the alert to show.
                    // Please see README for an explanation on
                    // why it's not used, in the Misc section.
//                    shouldPresentAlert.wrappedValue = true
                } else {
                    newSquad = state.squad
                }
            } else {
                newSquad = state.squad + [state.superhero]
            }

            return dataProvider.persist(newSquad, mySquadPath)
                .map { _ in Event.persistedSquad }
                .replaceError(with: .failedToLoad)
                .eraseToAnyPublisher()
        }
    }

    // Uncomment to test out the Alert

//    private static func whenRemovingFromSquad(
//        mySquadPath: String,
//        dataProvider: DataProviding<[Superhero], DataProvidingError>
//    ) -> Feedback<State, Event> {
//        Feedback { (state: State) -> AnyPublisher<Event, Never> in
//            guard case .removingFromSquad = state.status else { return Empty().eraseToAnyPublisher() }
//
//            var newSquad: [Superhero]
//            // TODO This would be better suited by a Set
//            if let index = state.squad.firstIndex(of: state.superhero) {
//                newSquad = state.squad
//                newSquad.remove(at: index)
//            } else {
//                newSquad = state.squad
//            }
//
//            return dataProvider.persist(newSquad, mySquadPath)
//                .map { _ in Event.persistedSquad(newSquad) }
//                .replaceError(with: .failedToLoad)
//                .eraseToAnyPublisher()
//        }
//    }

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
        var alert: Alert
        var status: Status
    }

    enum Status: Equatable {
        case idle
        case loading
        case loaded
        case failed
        case editingSquad
        // Uncomment to test out the Alert
//        case removingFromSquad
    }

    enum Event {
        case ui(UI)
        case loaded([Appearance], squad: [Superhero])
        case failedToLoad
        case persistedAppearances
        case persistedSquad

        enum UI {
            case onSquadButtonPress
            case onAppear
            case onDisappear
        }
    }
}

extension HeroDetailViewModel {
    struct Alert: Then {
        let superheroName: String
        var shouldPresent: Binding<Bool>
        var title: String { "Remove \(superheroName) from the squad?" }
        let removeButton = "Remove"
    }
}
