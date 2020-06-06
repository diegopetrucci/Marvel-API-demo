import SwiftUI

struct SuperheroList: View {
    let superheroes: [Superhero]
    let mySquad: [Superhero]

    var body: some View {
        VStack(spacing: 16) {
            ForEach(superheroes, id: \.self) { superhero in
                NavigationLink(
                    destination: HeroDetailContainerView( // TODO this should be injected
                        superhero: superhero,
                        mySquad: self.mySquad
                    )
                        .background(Colors.background)
                        // Ignoring the bottom safe area to make sure
                        // the background color applies to that as well.
                        .edgesIgnoringSafeArea(.bottom)
                    ,
                    label: {
                        SuperheroCell(superhero: superhero)
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
        let superheroes: [Superhero] = [
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture(),
            .fixture()
        ]

        return SuperheroList(
            superheroes: superheroes,
            mySquad: superheroes
        )
            .background(Colors.background)
    }
}
