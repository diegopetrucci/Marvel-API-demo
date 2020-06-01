import SwiftUI

struct RootView: View {
    let superheroes: [Superhero]

    var body: some View {
        ScrollView {
            Image(uiImage: UIImage(named: "marvel_logo")!) // TODO
                .resizable()
                .frame(width: 80, height: 32)
                .padding(6)
            Divider()
                .background(Color(red: 61 / 255, green: 64 / 255, blue: 69 / 255))
            SuperheroList(superheroes: superheroes)
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
        ])
    }
}
