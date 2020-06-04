import SwiftUI

struct SuperheroCell: View {
    let superhero: Superhero
    let backgroundColor: Color

    var body: some View {
        HStack(spacing: 16) {
            AsyncImageView(viewModel: AsyncImageViewModel(url: superhero.imageURL, api: MarvelAPI(remote: Remote())), contentMode: .fill) // TODO
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            Text(superhero.name)
                .foregroundColor(.white)
                .font(Font.system(size: 17))
                .fontWeight(.semibold)
            Spacer()
            Image(uiImage: UIImage(named: "disclosure")!) // TODO
        }
        .padding(16)
        .background(backgroundColor)
        .cornerRadius(8)
    }
}

struct SuperheroCell_Previews: PreviewProvider {
    static var previews: some View {
        SuperheroCell(
            superhero: .fixture(),
            backgroundColor: Color(red: 54 / 255, green: 59 / 255, blue: 69 / 255)
        )
    }
}
