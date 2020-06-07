import SwiftUI

struct HeroDetailContainerView: View {
    private let superhero: Superhero
    private let mySquad: [Superhero]
    private let appearancesDataProvider: DataProviding<[Appearance], DataProvidingError>
    private let mySquadDataProvider: DataProviding<[Superhero], DataProvidingError>
    @State private var shouldPresentAlert = false

    init(
        superhero: Superhero,
        mySquad: [Superhero],
        appearancesDataProvider: DataProviding<[Appearance], DataProvidingError>? = nil
    ) {
        self.superhero = superhero
        self.mySquad = mySquad

        // Workaround to the fact that:
        // 1. Having this injected is useful for testing
        // 2. A default parameter cannot be in the init as it needs `superhero.id`
        if let appearancesDataProvider = appearancesDataProvider {
            self.appearancesDataProvider = appearancesDataProvider
        } else {
            self.appearancesDataProvider = DataProvider(
                api: MarvelAPI(remote: Remote()),
                persister: Persister()
            ).appearancesDataProviding(superhero.id)
        }

        self.mySquadDataProvider = DataProvider(
            api: MarvelAPI(remote: Remote()),
            persister: Persister()
        ).mySquadDataProviding

        // This is what I've found so far to achieve
        // navigation as close to the spec. It is very clearly
        // not ideal, but it's the best possible (currently) with SwiftUI.
        UINavigationBar.appearance().tintColor = UIColor(red: 34 / 255, green: 37 / 255, blue: 43 / 255, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor(red: 34 / 255, green: 37 / 255, blue: 43 / 255, alpha: 1)
    }

    var body: some View {
        HeroDetailView(
            viewModel: HeroDetailViewModel(
                superhero: superhero,
                shouldPresentAlert: $shouldPresentAlert,
                appearancesDataProvider: appearancesDataProvider,
                mySquadDataProvider: mySquadDataProvider
            )
        )
            .background(Colors.background)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(false)
    }
}

struct HeroDetailContainerView_Previews: PreviewProvider {
    static var previews: some View {
        HeroDetailContainerView(
            superhero: .fixture(),
            mySquad: [.fixture(), .fixture(), .fixture()]
        )
    }
}
