import SwiftUI

struct RootView: View {
    let superheroes: [Superhero]
    let mySquadMembers: [Superhero]
    let backgroundColor: Color

    var body: some View {
        ScrollView {
            Image(uiImage: UIImage(named: "marvel_logo")!) // TODO
                .resizable()
                .frame(width: 80, height: 32)
                .padding(6)
            Divider()
                .background(Color(red: 61 / 255, green: 64 / 255, blue: 69 / 255))
            MySquadView(members: mySquadMembers)
                .padding(16)
                .background(backgroundColor)
            SuperheroList(
                superheroes: superheroes,
                cellBackgroundColor: Color(red: 54 / 255, green: 59 / 255, blue: 69 / 255)
            )
                .background(backgroundColor)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
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
        ],
            backgroundColor: Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255)
        )
    }
}
