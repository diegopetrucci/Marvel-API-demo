import SwiftUI

struct SuperheroList<Destination: View>: View {
    let superheroes: [Superhero]
    let mySquad: [Superhero]
    let destinationView: (Superhero, [Superhero]) -> Destination
    let asyncImageView: (_ url: URL, _ placeholder: UIImage, _ contentMode: ContentMode) -> AsyncImageView

    var body: some View {
        VStack(spacing: Spacing.default) {
            ForEach(superheroes, id: \.self) { superhero in
                NavigationLink(
                    destination: self.destinationView(superhero, self.mySquad)
                        .background(Colors.background)
                        // Ignoring the bottom safe area to make sure
                        // the background color applies to that as well.
                        .edgesIgnoringSafeArea(.bottom)
                    ,
                    label: {
                        SuperheroCell(
                            superhero: superhero,
                            asyncImageView: self.asyncImageView
                        )
                            .padding(.horizontal, Spacing.default)
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
            mySquad: superheroes,
            destinationView: { _, _ in EmptyView() },
            asyncImageView: { _, _, _ in .fixture() }
        )
            .background(Colors.background)
    }
}
