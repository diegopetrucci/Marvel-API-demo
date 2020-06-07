import SwiftUI

struct RootView<Destination: View>: View {
    @ObservedObject var viewModel: RootViewModel
    let mySquadViewModel: MySquadViewModel
    let mySquadMembers: [Superhero]
    let superheroDestinationView: (Superhero, [Superhero]) -> Destination
    let mySquadDestinationView: (Superhero, [Superhero]) -> Destination
    
    var body: some View {
        ScrollView {
            Image(uiImage: marvelLogo)
                .resizable()
                .frame(width: 80, height: 32)
                .padding(6)
            Divider()
                .background(Colors.divider)
            MySquadView(
                viewModel: mySquadViewModel,
                destinationView: mySquadDestinationView
            )
                .padding(Spacing.default)
                .background(Colors.background)
            supeheroes(for: viewModel.state.status)
        }
        .background(Colors.background)
        .onAppear { self.viewModel.send(event: .onAppear) }
        .onDisappear { self.viewModel.send(event: .onDisappear) }
    }
}

extension RootView {
    func supeheroes(for status: RootViewModel.Status) -> some View {
        switch status {
        case let .loaded(superheroes):
            return AnyView(
                SuperheroList(
                    superheroes: superheroes,
                    mySquad: mySquadMembers,
                    destinationView: superheroDestinationView
                )
            )
        case let .persisted(superheroes):
            return AnyView(
                SuperheroList(
                    superheroes: superheroes,
                    mySquad: mySquadMembers,
                    destinationView: superheroDestinationView
                )
            )
        case .idle, .loading:
            return AnyView(
                EmptyView()
            )
        case .failed:
            return AnyView(
                Button(
                    action: { self.viewModel.send(event: .retry) },
                    label: {
                        Text("Failed to load, tap to retry.")
                            .foregroundColor(Colors.text)
                            .font(Font.system(size: 17))
                            .fontWeight(.semibold)
                    }
                )
            )
        }
    }
}

extension RootView {
    var marvelLogo: UIImage { UIImage(named: "marvel_logo")! }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RootViewModel(
            dataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()),
                persister: Persister()
            ).superheroDataProvidingFixture(false)
        )

        let supeheroes: [Superhero] = [.fixture(), .fixture(), .fixture()]

        viewModel.state = .init(status: .loaded(supeheroes))

        let mySquadViewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()),
                persister: Persister()
            ).mySquadDataProvidingFixture(false)
        )

        let mySquadMembers: [Superhero] = [.fixture(), .fixture(), .fixture()]

        mySquadViewModel.state = .init(status: .loaded(mySquadMembers))

        return RootView(
            viewModel: viewModel,
            mySquadViewModel: mySquadViewModel,
            mySquadMembers: [
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture()
            ],
            superheroDestinationView: { _, _ in EmptyView() },
            mySquadDestinationView: { _, _ in EmptyView() }
        )
            .background(Colors.background)
    }
}
