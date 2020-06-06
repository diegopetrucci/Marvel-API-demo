import SwiftUI

struct HeroDetailView: View {
    @ObservedObject var viewModel: HeroDetailViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            AsyncImageView(
                viewModel: AsyncImageViewModel(
                    url: viewModel.state.superhero.imageURL,
                    dataProvider: ImageProvider(
                        api: MarvelAPI(remote: Remote()),
                        persister: ImagePersister()
                    ).imageDataProviding(viewModel.state.superhero.imageURL)
                ),
                contentMode: .fit
            ) // TODO
                // Setting `maxWidth` to `.inifinity`, which would be
                // the desidered behaviour as per spec, crashes the app.
                .frame(maxWidth: 300)
            HeroDescriptionView(
                superhero: viewModel.state.superhero,
                buttonText: viewModel.state.isPartOfSquad
                    ? "🔥 Fire from Squad"
                    : "💪 Recruit to Squad",
                buttonBackgroundColor: viewModel.state.isPartOfSquad
                    ? Colors.buttonBackgroundInverted
                    : Colors.buttonBackground,
                onButtonPress: { self.viewModel.send(event: .onSquadButtonPress) }
            )
                .padding(.horizontal, 16)
            HeroAppearancesView(appearances: viewModel.state.appearances)
                .padding(.horizontal, 16)
            Spacer()
            // The following is, from what it seems so far, the only way
            // to make sure the parent VStack fills the full width.
            // (Setting the frame to .infinity does not appear to be working.)
            HStack {
                Spacer()
            }
        }
        .onAppear(perform: { self.viewModel.send(event: .onAppear) })
        .onDisappear(perform: { self.viewModel.send(event: .onDisappear) })
    }
}

struct HeroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HeroDetailViewModel(
            superhero: .fixture(),
            appearancesDataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()), // TODO fixture
                persister: Persister() // TODO fixture
            ).appearancesDataProvidingFixture(false)(3),
            mySquadDataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()), // TODO fixture
                persister: Persister() // TODO fixture
            ).mySquadDataProvidingFixture(false)
        )

        let apperances: [Appearance] = [.fixture(), .fixture(), .fixture()]

        viewModel.state = .init(
            superhero: .fixture(),
            appearances: apperances,
            squad: [.fixture(), .fixture(), .fixture()],
            status: .loaded(appearances: apperances)
        )

        return HeroDetailView(viewModel: viewModel)
            .background(Colors.background)
    }
}
