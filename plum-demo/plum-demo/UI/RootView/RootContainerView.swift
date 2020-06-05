import SwiftUI
import class Combine.AnyCancellable // todo remove
import Combine // todo remove

struct RootContainerView: View {
    @State var superheroes: [Superhero] = []
//    @State var mySquadMembers: [Superhero] = [] // TODO
    var mySquadMembers: [Superhero] { superheroes } // TODO remove
    @State var cancellables = Set<AnyCancellable>()

    var dataProvider: DataProviding<[Superhero], DataProvidingError>

    var body: some View {
        NavigationView {
            RootView(
                superheroes: superheroes,
                mySquadMembers: mySquadMembers,
                backgroundColor: Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255)
            )
                .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255))
                // Ignoring the bottom safe area to make sure
                // the background color applies to that as well.
                .edgesIgnoringSafeArea(.bottom)
                // The title has to be set to an empty string,
                // otherwise SwiftUI ignores `.navigationBarHidden(true)`
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
        .onAppear {
            self.dataProvider.fetch("/superheroes")
                .replaceError(with: [])
                .flatMap { _superheroes -> AnyPublisher<[Superhero], Never> in
                    self.dataProvider.persist(_superheroes, "/superheroes")
                        .map { _ in _superheroes }
                        .eraseToAnyPublisher()
                }
                .receive(on: RunLoop.main)
                .assign(to: \.superheroes, on: self)
                .store(in: &self.cancellables)
        }
    }
}

struct RootContainerView_Previews: PreviewProvider {
    static var previews: some View {
        RootContainerView(
            superheroes: [
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture()
            ],
            dataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()), // TODO fixture
                persister: Persister() // TODO fixture
            ).superheroDataProvidingFixture(false)
        )
    }
}
