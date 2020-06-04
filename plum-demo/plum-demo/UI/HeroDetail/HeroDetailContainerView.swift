import SwiftUI
import class Combine.AnyCancellable

struct HeroDetailContainerView: View {
    @State var appearances: [Appearance] = []

    @State private var cancellabels = Set<AnyCancellable>()
    private let superhero: Superhero
    private let api: API

    init(superhero: Superhero, api: API) {
        self.superhero = superhero
        self.api = api

        // This is what I've found so far to achieve
        // navigation as close to the spec. It is very clearly
        // not ideal, but it's the best possible (currently) with SwiftUI.
        UINavigationBar.appearance().tintColor = UIColor(red: 34 / 255, green: 37 / 255, blue: 43 / 255, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor(red: 34 / 255, green: 37 / 255, blue: 43 / 255, alpha: 1)
    }

    var body: some View {
        HeroDetailView(superhero: superhero, appearances: appearances)
            .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(false)
        .onAppear {
            self.api.comics(for: self.superhero.id)
                .map { comics -> [Appearance] in
                    comics.map { comic -> Appearance in
                        Appearance(
                            imageURL: comic.thumbnail.url,
                            title: comic.title
                        )
                    }
                }
            .receive(on: RunLoop.main)
            .replaceError(with: [])
            .assign(to: \.appearances, on: self)
            .store(in: &self.cancellabels)
        }
    }
}

struct HeroDetailContainerView_Previews: PreviewProvider {
    static var previews: some View {
        HeroDetailContainerView(
            superhero: .fixture(),
            api: MarvelAPI(remote: Remote())
        )
    }
}
