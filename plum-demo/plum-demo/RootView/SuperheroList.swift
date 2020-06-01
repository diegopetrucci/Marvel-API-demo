import SwiftUI

struct SuperheroList: View {
    let superheroes: [Superhero]

    var body: some View {
        VStack(spacing: 16) {
            ForEach(superheroes, id: \.self) {
                SuperheroCell(superhero: $0)
            }
        }
        .padding(16)
    }
}

struct SuperheroList_Previews: PreviewProvider {
    static var previews: some View {
        SuperheroList(
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
