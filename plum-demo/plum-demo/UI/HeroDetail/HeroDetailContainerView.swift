import SwiftUI

struct HeroDetailContainerView: View {
    private let superhero: Superhero
    private let mySquad: [Superhero]
    private let appearancesDataProvider: DataProviding<[Appearance], DataProvidingError>
    private let mySquadDataProvider: DataProviding<[Superhero], DataProvidingError>

    init(superhero: Superhero, mySquad: [Superhero]) {
        self.superhero = superhero
        self.mySquad = mySquad

        self.appearancesDataProvider = DataProvider(
            api: MarvelAPI(remote: Remote()),
            persister: Persister()
        ).appearancesDataProviding(superhero.id)

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
