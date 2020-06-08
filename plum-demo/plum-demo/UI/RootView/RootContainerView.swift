import SwiftUI

struct RootContainerView: View {
    var mySquadMembers: [Superhero] = []

    var body: some View {
        NavigationView {
            RootView(
                viewModel: RootViewModel(
                    dataProvider: DataProvider(
                        api: MarvelAPI(remote: Remote()),
                        persister: Persister()
                    ).superheroDataProviding
                ),
                mySquadViewModel: MySquadViewModel(
                    dataProvider: DataProvider(
                        api: MarvelAPI(remote: Remote()),
                        persister: Persister()
                    ).mySquadDataProviding
                ),
                mySquadMembers: mySquadMembers,
                superheroDestinationView: { superhero, mySquad in
                    HeroDetailContainerView(superhero: superhero, mySquad: mySquad)
                },
                mySquadDestinationView: { superhero, mySquad in
                    HeroDetailContainerView(superhero: superhero, mySquad: mySquad)
                }
            )
                .background(Colors.background)
                // Ignoring the bottom safe area to make sure
                // the background color applies to that as well.
                .edgesIgnoringSafeArea(.bottom)
                // The title has to be set to an empty string,
                // otherwise SwiftUI ignores `.navigationBarHidden(true)`
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
}

struct RootContainerView_Previews: PreviewProvider {
    static var previews: some View {
        RootContainerView()
    }
}
