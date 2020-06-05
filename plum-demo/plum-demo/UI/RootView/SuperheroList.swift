import SwiftUI

struct SuperheroList: View {
    let superheroes: [Superhero]
    let backgroundColor: Color
    let cellBackgroundColor: Color

    var body: some View {
        VStack(spacing: 16) {
            ForEach(superheroes, id: \.self) { superhero in
                NavigationLink(
                    destination: HeroDetailContainerView( // TODO this should be injected
                        superhero: superhero,
                        dataProviding: DataProvider(
                            api: MarvelAPI(remote: Remote()),
                            persister: Persister()
                        ).appearancesDataProviding(superhero.id)
                    )
                        .background(self.backgroundColor)
                        // Ignoring the bottom safe area to make sure
                        // the background color applies to that as well.
                        .edgesIgnoringSafeArea(.bottom)
                    ,
                    label: {
                        SuperheroCell(
                            superhero: superhero,
                            backgroundColor: self.cellBackgroundColor
                        )
                        .padding(.horizontal, 16)
                    }
                )
                    .buttonStyle(PlainButtonStyle())
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
            backgroundColor: Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255),
            cellBackgroundColor: Color(red: 54 / 255, green: 59 / 255, blue: 69 / 255)
        )
    }
}
