import SwiftUI

struct HeroDescriptionView: View {
    let superhero: Superhero
    let buttonText: String
    let buttonBackgroundColor: Color
    let onButtonPress: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(superhero.name)
                .foregroundColor(Colors.text)
                .font(Font.system(size: 34))
                .fontWeight(.bold)
                .alignmentGuide(.leading) { d in d[.leading] } // TODO: this is not working
            Button(
                action: { self.onButtonPress() },
                label: {
                    Text(buttonText)
                        .foregroundColor(Colors.text)
                        .font(Font.system(size: 17))
                        .fontWeight(.semibold)
                }
            )
                // `idealWidth` and `idealHeight` here make the button wrap the text,
                // similar to required content hugging
                .frame(width: 288, height: 43)
                .background(buttonBackgroundColor)
                // SwiftUI truly works in misterious ways. I had to make the border
                // a lot thicker to be able to "cover" for the fact that the internal
                // button frame is not corner radius-ed. As far as I understand this
                // might be a SwiftUI bug.
                .border(Colors.buttonBorder)
                .cornerRadius(10)
                .shadow(radius: 10)
            Text(superhero.description)
                .foregroundColor(Colors.text)
                .font(Font.system(size: 17))
                .fontWeight(.regular)
                .alignmentGuide(.leading) { d in d[.leading] }
        }
    }
}

struct HeroDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        HeroDescriptionView(
            superhero: .fixture(),
            buttonText: "💪 Recruit to Squad",
            buttonBackgroundColor: Colors.buttonBackground,
            onButtonPress: {}
        )
            .background(Colors.background)
    }
}
