import SwiftUI

struct SuperheroList: View {
    let superheroes: [Superhero]
    let cellBackgroundColor: Color

    var body: some View {
        VStack(spacing: 16) {
            ForEach(superheroes, id: \.self) {
                SuperheroCell(
                    superhero: $0,
                    backgroundColor: self.cellBackgroundColor
                )
                    .padding(.horizontal, 16)
            }
        }
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
        ],
            cellBackgroundColor: Color(red: 54 / 255, green: 59 / 255, blue: 69 / 255)
        )
    }
}