import SwiftUI

struct SuperheroCell: View {
    let superhero: Superhero
    let asyncImageView: (_ url: URL, _ placeholder: UIImage, _ contentMode: ContentMode) -> AsyncImageView

    var body: some View {
        HStack(spacing: Spacing.default) {
            if superhero.imageURL.isNotNil {
                asyncImageView(superhero.imageURL!, UIImage(), .fit)
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
        SuperheroCell(
            superhero: .fixture(),
            asyncImageView: { _, _, _ in .fixture() }
        )
            .background(Colors.cellBackground)
    }
}
