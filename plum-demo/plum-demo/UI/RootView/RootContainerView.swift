import SwiftUI

struct RootContainerView: View {
    var superheroes: [Superhero]
    var mySquadMembers: [Superhero]

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
            mySquadMembers: [
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture()
            ]
        )
    }
}
