import SwiftUI

struct HeroDetailView: View {
    let superhero: Superhero
    let appearances: [Appearance]
    
    var body: some View {
        VStack(spacing: 24) {
            AsyncImageView(
                viewModel: AsyncImageViewModel(
                    url: superhero.imageURL,
                    dataProvider: ImageProvider(
                        api: MarvelAPI(remote: Remote()),
                        persister: ImagePersister()
                    ).imageDataProviding(.fixture())
                ),
                contentMode: .fit
            ) // TODO
            HeroDescriptionView(superhero: superhero)
             .padding(.horizontal, 16)
            HeroAppearancesView(appearances: appearances)
                .padding(.horizontal, 16)
            Spacer()
            // The following is, from what it seems so far, the only way
            // to make sure the parent VStack fills the full width.
            // (Setting the frame to .infinity does not appear to be working.)
            HStack {
                Spacer()
            }
        }
    }
}

struct HeroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HeroDetailView(
            superhero: .fixture(),
            appearances: [.fixture(), .fixture(), .fixture()]
        )
            .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255))
    }
}
