import SwiftUI

struct PreviousIssueView: View {
    let appearance: Appearance

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if appearance.imageURL.isNotNil {
                AsyncImageView(
                    viewModel: AsyncImageViewModel(
                        url: appearance.imageURL,
                        dataProvider: ImageProvider(
                            api: MarvelAPI(remote: Remote()),
                            persister: ImagePersister()
                        ).imageDataProviding(appearance.imageURL!) // SwiftUI not supporting optional binding
                    )
                )
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
            )
        )
            .background(Colors.background)
    }
}
