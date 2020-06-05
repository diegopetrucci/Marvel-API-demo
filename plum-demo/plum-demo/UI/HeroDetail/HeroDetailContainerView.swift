import SwiftUI
import class Combine.AnyCancellable // REMOVe
import Combine // TODO

struct HeroDetailContainerView: View {
    @State var appearances: [Appearance] = []

    @State private var cancellabels = Set<AnyCancellable>()
    private let superhero: Superhero
    private let dataProviding: DataProviding<[Appearance], DataProvidingError>

    init(
        superhero: Superhero,
        dataProviding: DataProviding<[Appearance], DataProvidingError>
    ) {
        self.superhero = superhero
        self.dataProviding = dataProviding

        // This is what I've found so far to achieve
        // navigation as close to the spec. It is very clearly
        // not ideal, but it's the best possible (currently) with SwiftUI.
        UINavigationBar.appearance().tintColor = UIColor(red: 34 / 255, green: 37 / 255, blue: 43 / 255, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor(red: 34 / 255, green: 37 / 255, blue: 43 / 255, alpha: 1)
    }

    var body: some View {
        HeroDetailView(superhero: superhero, appearances: appearances)
            .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(false)
            .onAppear {
                self.dataProviding.fetch("\(self.superhero.id)" + "/appearances")
                    .replaceError(with: [])
                    .flatMap { _appearances -> AnyPublisher<[Appearance], Never> in
                        self.dataProviding.persist(_appearances, "\(self.superhero.id)" + "/appearances")
                            .map { _ in _appearances }
                            .eraseToAnyPublisher()
                }
                .receive(on: RunLoop.main)
                .assign(to: \.appearances, on: self)
                .store(in: &self.cancellabels)
        }
    }
}

struct HeroDetailContainerView_Previews: PreviewProvider {
    static var previews: some View {
        HeroDetailContainerView(
            superhero: .fixture(),
            dataProviding: DataProvider(
                api: MarvelAPI(remote: Remote()), // TODO fixture
                persister: Persister() // TODO fixture
            ).appearancesDataProvidingFixture(false)(Superhero.fixture().id)
        )
    }
}
