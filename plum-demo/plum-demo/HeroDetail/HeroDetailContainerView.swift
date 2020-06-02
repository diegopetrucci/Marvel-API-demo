import SwiftUI

struct HeroDetailContainerView: View {
    let heroDetail: HeroDetail
    let appearances: [Appearance]

    var body: some View {
            HeroDetailView(
                heroDetail: heroDetail,
                appearances: appearances
            )
            .navigationBarTitle("")
            .navigationBarHidden(true)
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
