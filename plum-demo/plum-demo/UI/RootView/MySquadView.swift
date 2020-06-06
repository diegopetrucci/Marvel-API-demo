import SwiftUI

struct MySquadView: View {
    @ObservedObject var viewModel: MySquadViewModel
    @State private var selectedMemberID: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header(for: viewModel.state.status)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    squadMembers(for: viewModel.state.status)
                }
            }
        }
        .onAppear { self.viewModel.send(event: .onAppear) }
        .onDisappear { self.viewModel.send(event: .onDisappear) }
    }
}

extension MySquadView {
    func header(for status: MySquadViewModel.Status) -> some View {
        switch status {
        case .loaded:
            return AnyView(
                Text("My Squad")
                    .foregroundColor(Colors.text)
                    .font(Font.system(size: 20))
                    .fontWeight(.semibold)
            )
        case .idle, .loading, .failed:
            return AnyView(
                EmptyView()
            )
        }
    }
}

extension MySquadView {
    func squadMembers(
        for status: MySquadViewModel.Status
    ) -> some View {
        switch status {
        case let .loaded(squadMembers):
            return AnyView(
                ForEach(squadMembers, id: \.self) { member in
                    NavigationLink(
                        destination: HeroDetailContainerView( // TODO this should be injected
                            superhero: member,
                            mySquad: squadMembers
                        )
                            .background(Colors.background)
                            // Ignoring the bottom safe area to make sure
                            // the background color applies to that as well.
                            .edgesIgnoringSafeArea(.bottom)
                        ,
                        tag: member.id,
                        selection: self.$selectedMemberID,
                        label: { self.navigationLinkLabel(for: member) }
                    )
                }
            )
        case .idle, .loading, .failed:
            return AnyView(
                EmptyView()
            )
        }
    }

    func navigationLinkLabel(for member: Superhero) -> some View {
        Button(
            action: { self.selectedMemberID = member.id },
            label: {
                VStack(spacing: 4) {
                    AsyncImageView(
                        viewModel: AsyncImageViewModel(
                            url: member.imageURL,
                            dataProvider: ImageProvider(
                                api: MarvelAPI(remote: Remote()),
                                persister: ImagePersister()
                            ).imageDataProviding(member.imageURL)
                        ),
                        contentMode: .fill
                    ) // TODO
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                    Text(member.name)
                        .foregroundColor(Colors.text)
                        .font(Font.system(size: 13))
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                    // I've chosen here not to set a maxmium width
                    // to avoid problems when the user has
                    // set a bigger text size
                    .frame(idealWidth: 64)
        }
        )
    }
}

struct MySquadView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()), // TODO fixture
                persister: Persister() // TODO fixture
            ).mySquadDataProvidingFixture(false)
        )
        
        let supeheroes: [Superhero] = [.fixture(), .fixture(), .fixture()]
        
        viewModel.state = .init(status: .loaded(supeheroes))
        
        return MySquadView(viewModel: viewModel)
            .background(Colors.cellBackground)
    }
}
