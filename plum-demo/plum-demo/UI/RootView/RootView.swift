import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel: RootViewModel
    let mySquadViewModel: MySquadViewModel
    let mySquadMembers: [Superhero]
    
    var body: some View {
        ScrollView {
            Image(uiImage: UIImage(named: "marvel_logo")!) // TODO
                .resizable()
                .frame(width: 80, height: 32)
                .padding(6)
            Divider()
                .background(Colors.divider)
            MySquadView(viewModel: mySquadViewModel)
                .padding(16)
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
                    mySquad: mySquadMembers
                )
            )
        case let .persisted(superheroes):
            return AnyView(
                SuperheroList(
                    superheroes: superheroes,
                    mySquad: mySquadMembers
                )
            )
        case .failed, .idle, .loading:
            return AnyView(
                EmptyView() // TODO error state
            )
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RootViewModel(
            dataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()), // TODO fixture
                persister: Persister() // TODO fixture
            ).superheroDataProvidingFixture(false)
        )

        let supeheroes: [Superhero] = [.fixture(), .fixture(), .fixture()]

        viewModel.state = .init(status: .loaded(supeheroes))

        let mySquadViewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()), // TODO fixture
                persister: Persister() // TODO fixture
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
            ]
        )
            .background(Colors.background)
    }
}
