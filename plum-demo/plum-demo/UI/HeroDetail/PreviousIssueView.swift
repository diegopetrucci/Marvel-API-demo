import SwiftUI

struct PreviousIssueView: View {
    let appearance: Appearance
    let asyncImageView: (_ url: URL, _ placeholder: UIImage, _ contentMode: ContentMode) -> AsyncImageView

    var body: some View {
        VStack(alignment: .center, spacing: Spacing.default / 2) {
            if appearance.imageURL.isNotNil {
                asyncImageView(appearance.imageURL!, UIImage(), .fit)
                    .frame(idealWidth: 136, idealHeight: 192)
            }
            Text(appearance.title)
                .foregroundColor(Colors.text)
                .font(Font.system(size: 13))
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

struct PreviousIssueView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousIssueView(
            appearance: Appearance(
                imageURL: .fixture(),
                title: "Hulk (2008) #55"
            ),
            asyncImageView: { _, _, _ in .fixture() }
        )
            .background(Colors.background)
    }
}
