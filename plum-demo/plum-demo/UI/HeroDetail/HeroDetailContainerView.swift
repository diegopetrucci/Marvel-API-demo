import SwiftUI

struct HeroDetailContainerView: View {
    let heroDetail: HeroDetail
    let appearances: [Appearance]

    init(
        heroDetail: HeroDetail,
        appearances: [Appearance]
    ) {
        self.heroDetail = heroDetail
        self.appearances = appearances

        // This is what I've found so far to achieve
        // navigation as close to the spec. It is very clearly
        // not ideal, but it's the best possible (currently) with SwiftUI.
        UINavigationBar.appearance().tintColor = UIColor(red: 34 / 255, green: 37 / 255, blue: 43 / 255, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor(red: 34 / 255, green: 37 / 255, blue: 43 / 255, alpha: 1)
    }

    var body: some View {
        HeroDetailView(
            heroDetail: heroDetail,
            appearances: appearances
        )
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(false)
    }
}

struct HeroDetailContainerView_Previews: PreviewProvider {
    static var previews: some View {
        HeroDetailContainerView(
            heroDetail: .fixture(),
            appearances: [.fixture(), .fixture(), .fixture()]
        )
    }
}
