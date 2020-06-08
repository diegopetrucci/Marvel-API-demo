import SwiftUI

struct MySquadView<Destination: View>: View {
    @ObservedObject var viewModel: MySquadViewModel
    @State private var selectedMemberID: Int? = nil
    let destinationView: (Superhero, [Superhero]) -> Destination
    let asyncImageView: (_ url: URL, _ placeholder: UIImage, _ contentMode: ContentMode) -> AsyncImageView

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.default / 2) {
                    ForEach(viewModel.state.squad, id: \.self) { member in
                        NavigationLink(
                            destination: self.destinationView(member, self.viewModel.state.squad)
                                .background(Colors.background)
                                // Ignoring the bottom safe area to make sure
                                // the background color applies to that as well.
                                .edgesIgnoringSafeArea(.bottom)
                            ,
                            tag: member.id,
                            selection: self.$selectedMemberID,
                            label: { self.navigationLinkLabel(for: member) }
                        )
                            .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
            // If you want to have fun try uncommenting this, the images in
            // ScrollView start to flicker randomly when trying to go to
            // a detail view.
//        .id(UUID().uuidString)
        .onAppear { self.viewModel.send(event: .onAppear) }
        .onDisappear { self.viewModel.send(event: .onDisappear) }
    }
}

extension MySquadView {
    func header() -> some View {
        switch viewModel.state.status {
        case .loaded:
            if viewModel.state.squad.isNotEmpty {
                return AnyView(
                    Text("My Squad")
                        .foregroundColor(Colors.text)
                        .font(Font.system(size: 20))
                        .fontWeight(.semibold)
                )
            } else {
                return AnyView(
                   Text("")
                )
            }
        case .idle, .loading, .failed:
            return AnyView(
                Text("")
            )
        }
    }
}

extension MySquadView {
    func navigationLinkLabel(for member: Superhero) -> some View {
        Button(
            action: { self.selectedMemberID = member.id },
            label: {
                VStack(spacing: 4) {
                    if member.imageURL.isNotNil {
                        asyncImageView(member.imageURL!, UIImage(), .fit)
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
                }
                    // I've chosen here not to set a maxmium width
                    // to avoid problems when the user has
                    // set a bigger text size
                    .frame(idealWidth: 64)
        }
        )
            .buttonStyle(PlainButtonStyle())
    }
}

struct MySquadView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MySquadViewModel(
            dataProvider: DataProvider(
                api: MarvelAPI(remote: Remote()),
                persister: Persister()
            ).mySquadDataProvidingFixture(false)
        )
        
        let supeheroes: [Superhero] = [.fixture(), .fixture(), .fixture()]
        
        viewModel.state = .init(status: .loaded, squad: supeheroes)
        
        return MySquadView(
            viewModel: viewModel,
            destinationView: { _, _ in EmptyView() },
            asyncImageView: { url, placeholder, contentMode in
                AsyncImageView(
                    sourcePublisher: ImageProvider(
                        api: MarvelAPI(remote: Remote()),
                        persister: ImagePersister()
                    ).imageDataProviding(url)
                        .fetch(url.absoluteString)
                        .ignoreError(),
                    placeholder: placeholder,
                    contentMode: contentMode
                )
            }
        )
            .background(Colors.cellBackground)
    }
}
