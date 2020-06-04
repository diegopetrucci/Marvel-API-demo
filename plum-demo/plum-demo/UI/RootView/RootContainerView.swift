import SwiftUI
import class Combine.AnyCancellable

struct RootContainerView: View {
    @State var superheroes: [Superhero] = []
//    @State var mySquadMembers: [Superhero] = [] // TODO
    var mySquadMembers: [Superhero] { superheroes } // TODO remove
    @State var cancellables = Set<AnyCancellable>()

    var api: API

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
            self.api.characters()
                .map { characters -> [Superhero] in
                    return characters.map { character in // TODO remove this mapping from there
                        Superhero(
                            id: character.id,
                            imageURL: character.thumbnail.url,
                            name: character.name,
                            description: character.description
                        )
                    }
            }
            .receive(on: RunLoop.main)
            .replaceError(with: [])
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
            api: MarvelAPI(remote: Remote()) // TODO fixtures
        )
    }
}
