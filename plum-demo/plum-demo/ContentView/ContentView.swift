import SwiftUI

struct ContentView: View {
    var superheroes: [Superhero]
    var mySquadMembers: [Superhero]

    var body: some View {
        RootView(
            superheroes: superheroes,
            mySquadMembers: mySquadMembers,
            backgroundColor: Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255)
        )
        .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255))
            // Ignoring the bottom safe area to make sure
            // the background color applies to that as well.
            .edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            superheroes: [
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture()
            ],
            mySquadMembers: [
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture()
            ]
        )
    }
}
