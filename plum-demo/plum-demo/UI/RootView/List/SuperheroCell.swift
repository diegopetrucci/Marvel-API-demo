import SwiftUI

struct SuperheroCell: View {
    let superhero: Superhero

    var body: some View {
        HStack(spacing: Spacing.default) {
            if superhero.imageURL.isNotNil {
                AsyncImageView(
                    viewModel: AsyncImageViewModel(
                        url: superhero.imageURL,
                        dataProvider: ImageProvider(
                            api: MarvelAPI(remote: Remote()),
                            persister: ImagePersister()
                        ).imageDataProviding(superhero.imageURL!) // SwiftUI not supporting optional binding
                    ),
                    contentMode: .fill
                )
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
            }
            Text(superhero.name)
                .foregroundColor(Colors.text)
                .font(Font.system(size: 17))
                .fontWeight(.semibold)
            Spacer()
            Image(uiImage: UIImage(named: "disclosure")!)
        }
        .padding(Spacing.default)
        .background(Colors.cellBackground)
        .cornerRadius(8)
    }
}

struct SuperheroCell_Previews: PreviewProvider {
    static var previews: some View {
        SuperheroCell(superhero: .fixture())
            .background(Colors.cellBackground)
    }
}
