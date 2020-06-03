import SwiftUI

struct HeroAppearancesView: View {
    // It can make for an interesting discussion whether or not
    // the view should be able to enter this array and know how
    // many views to pick, or if it should be restricted from that
    // and spoon-fed its content (states).
    let appearances: [Appearance]

    var body: some View {
        VStack(spacing: 16) {
            Text("Last appeared in")
                .foregroundColor(.white)
                .font(Font.system(size: 20))
                .fontWeight(.semibold)
                .alignmentGuide(.leading) { d in d[.leading] } // TODO: this is not working
            HStack(spacing: 16) { // TODO if there is only one
                if appearances.count > 0 {
//                    optionalOrFallbackView(
//                        condition: appearances.first,
//                        desiredView: PreviousIssueView,
//                        fallbackView: EmptyView
//                    )
                    PreviousIssueView(appearance: appearances.first!) // TODO
                }
                if appearances.second != nil {
                    PreviousIssueView(appearance: appearances.second!) // TODO
                }
            }
//            if appearances.count > 2 {
//                ZStack {
//                    Rectangle()
//                        .frame(width: .infinity, height: 20) // TODO
//                    Text("and \(appearances.count - 2) other comic\(appearances.count > 3 ? "s" : "")") // TODO pragmatically there should be two strings here, not all languages behave like english with plurals
//                    .foregroundColor(.white)
//                    .font(Font.system(size: 17))
//                    .fontWeight(.regular)
//                }
//            }
        }
    }
}

extension Array {
    var second: Element? {
        self.count > 1
            ? self[1]
            : nil
    }
}

//// Workaround to SwiftUI not supporting optional-binding.
//// There are a few good alternatives here https://twitter.com/diegopetrucci/status/1229028547743952896?s=21
//// I'm just using this because I like it :)
//func optionalOrFallbackView<T: View, U: View, V>(
//    condition: Optional<V>,
//    desiredView: (V) -> T,
//    fallbackView: () -> U
//) -> _ConditionalContent<T, U> {
//    if let unwrapped = condition {
//        return ViewBuilder.buildEither(first: desiredView(unwrapped))
//    } else {
//        return ViewBuilder.buildEither(second: fallbackView())
//    }
//}

struct HeroAppearancesView_Previews: PreviewProvider {
    static var previews: some View {
        HeroAppearancesView(
            appearances: [.fixture(), .fixture(), .fixture()]
        )
            .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255))
    }
}
