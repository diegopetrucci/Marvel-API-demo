import SwiftUI

struct HeroAppearancesView: View {
    // It can make for an interesting discussion whether or not
    // the view should be able to enter this array and know how
    // many views to pick, or if it should be restricted from that
    // and spoon-fed its content (states).
    let appearances: [Appearance]

    var body: some View {
        VStack(spacing: 16) {
            if appearances.count > 0 {
                Text("Last appeared in")
                    .foregroundColor(Colors.text)
                    .font(Font.system(size: 20))
                    .fontWeight(.semibold)
                    .alignmentGuide(.leading) { d in d[.leading] } // TODO: this is not working
            }
            HStack(alignment: .center, spacing: 16) {
                if appearances.count > 0 {
                    PreviousIssueView(appearance: appearances.first!) // TODO
                }

                if appearances.second.isNotNil {
                    PreviousIssueView(appearance: appearances.second!) // TODO
                }
            }

            if appearances.count > 2 {
                Text(moreComicsText(for: appearances.count))
                    .foregroundColor(Colors.text)
                    .font(Font.system(size: 17))
                    .fontWeight(.regular)
            }
        }
    }
}

extension HeroAppearancesView {
    // This is an oversimplified scenario, but at
    // least it tries to cater to languages where
    // plurar might be more complex than adding an `s`
    func moreComicsText(for count: Int) -> String {
        switch count {
        case 3:
            return "and 1 other comic"
        case 3...:
            return "and \(count - 2) other comics"
        default:
            fatalError("This is an impossible state")
        }
    }
}

struct HeroAppearancesView_Previews: PreviewProvider {
    static var previews: some View {
        HeroAppearancesView(
            appearances: [.fixture(), .fixture(), .fixture()]
        )
            .background(Colors.background)
    }
}
