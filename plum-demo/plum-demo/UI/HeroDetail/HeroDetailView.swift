import SwiftUI

struct HeroDetailView: View {
    @ObservedObject var viewModel: HeroDetailViewModel
    let asyncImageView: (_ url: URL, _ placeholder: UIImage, _ contentMode: ContentMode) -> AsyncImageView
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if viewModel.state.superhero.imageURL.isNotNil {
                    asyncImageView(viewModel.state.superhero.imageURL!, UIImage(), .fit)
                        // Setting `maxWidth` to `.inifinity`, which would be
                        // the desidered behaviour as per spec, crashes the app.
                        .frame(maxWidth: .infinity, maxHeight: 300)
                }
                HeroDescriptionView(
                    superhero: viewModel.state.superhero,
                    button: .init(
                        text: viewModel.state.isPartOfSquad
                            ? "🔥 Fire from Squad"
                            : "💪 Recruit to Squad",
                        backgroundColor: viewModel.state.isPartOfSquad
                            ? Colors.buttonBackgroundInverted
                            : Colors.buttonBackground,
                        backgroundColorPressed: viewModel.state.isPartOfSquad
                            ? Colors.buttonBackgroundInvertedPressed
                            : Colors.buttonBackgroundPressed
                        ,
                        onPress: { self.viewModel.send(event: .onSquadButtonPress) }
                    )
                )
                    .padding(.horizontal, Spacing.default)
                HeroAppearancesView(
                    appearances: viewModel.state.appearances,
                    asyncImageView: { _, _, _ in .fixture() }
                )
                    .padding(.horizontal, Spacing.default)
                Spacer()
                // The following is, from what it seems so far, the only way
                // to make sure the parent VStack fills the full width.
                // (Setting the frame to .infinity does not appear to be working.)
                HStack {
                    Spacer()
                }
            }
        }
        .onAppear(perform: { self.viewModel.send(event: .onAppear) })
        .onDisappear(perform: { self.viewModel.send(event: .onDisappear) })
        // Uncomment to test Alert
//        .alert(isPresented: self.viewModel.state.alert.shouldPresent) { () -> Alert in
//            Alert(
//                title: Text(self.viewModel.state.alert.title),
//                primaryButton: .cancel(),
//                secondaryButton: .destructive(Text(self.viewModel.state.alert.removeButton))
//            )
//        }
    }
}

struct HeroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HeroDetailViewModel(
            superhero: .fixture(),
            shouldPresentAlert: .constant(false),
            appearancesDataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()),
                persister: Persister()
            ).appearancesDataProvidingFixture(false)(3),
            mySquadDataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()),
                persister: Persister()
            ).mySquadDataProvidingFixture(false)
        )

        let apperances: [Appearance] = [.fixture(), .fixture(), .fixture()]

        viewModel.state = .init(
            superhero: .fixture(),
            appearances: apperances,
            squad: [.fixture(), .fixture(), .fixture()],
            alert: HeroDetailViewModel.Alert(
                superheroName: "Name",
                shouldPresent: .init(.constant(false)) ?? .constant(false)
            ),
            status: .loaded
        )

        return HeroDetailView(
            viewModel: viewModel,
            asyncImageView: { _, _, _ in .fixture() }
        )
            .background(Colors.background)
    }
}
