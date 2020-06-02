import SwiftUI

struct HeroDetailView: View {
    let heroDetail: HeroDetail
    let appearances: [Appearance]
    
    var body: some View {
        VStack(spacing: 24) {
            Image(uiImage: heroDetail.headerImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(idealWidth: .infinity)
            HeroDescriptionView(heroDetail: heroDetail)
            HeroAppearancesView(appearances: appearances)
            Spacer()
        }
    }
}

struct HeroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HeroDetailView(
            heroDetail: .fixture(),
            appearances: [.fixture(), .fixture(), .fixture()]
        )
            .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255))
    }
}
