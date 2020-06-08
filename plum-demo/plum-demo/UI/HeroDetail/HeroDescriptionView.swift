import SwiftUI

struct HeroDescriptionView: View {
    let superhero: Superhero
    let button: RecruitButton

    var body: some View {
        VStack(spacing: Spacing.default) {
            Text(superhero.name)
                .foregroundColor(Colors.text)
                .font(Font.system(size: 34))
                .fontWeight(.bold)
                .alignmentGuide(.leading) { d in d[.leading] } // Note: this is not working. A SwiftUI bug?
            Button(
                action: { self.button.onPress() },
                label: {
                    Text(button.text)
                        .foregroundColor(Colors.text)
                        .font(Font.system(size: 17))
                        .fontWeight(.semibold)
                }
            )
                .buttonStyle(HighlightableButton(
                    backgroundColor: button.backgroundColor,
                    backgroundColorPressed: button.backgroundColorPressed
                ))
            Text(superhero.description)
                .foregroundColor(Colors.text)
                .font(Font.system(size: 17))
                .fontWeight(.regular)
                .alignmentGuide(.leading) { d in d[.leading] }
        }
    }
}

extension HeroDescriptionView {
    struct RecruitButton {
        let text: String
        let backgroundColor: Color
        let backgroundColorPressed: Color
        let onPress: () -> Void
    }
}

extension HeroDescriptionView {
    struct HighlightableButton: ButtonStyle {
        let backgroundColor: Color
        let backgroundColorPressed: Color
        
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                // `idealWidth` and `idealHeight` here make the button wrap the text,
                // similar to required content hugging
                .frame(width: 288, height: 43)
                .background(configuration.isPressed ? backgroundColorPressed : backgroundColor)
                // SwiftUI truly works in misterious ways. I had to make the border
                // a lot thicker to be able to "cover" for the fact that the internal
                // button frame is not corner radius-ed. As far as I understand this
                // might be a SwiftUI bug.
                .border(configuration.isPressed ? Colors.buttonBorderPressed : Colors.buttonBorder, width: 4)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
    }
}

struct HeroDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        HeroDescriptionView(
            superhero: .fixture(),
            button: .init(
                text: "💪 Recruit to Squad",
                backgroundColor: Colors.buttonBackground,
                backgroundColorPressed: Colors.buttonBackgroundPressed,
                onPress: {}
            )
        )
            .background(Colors.background)
    }
}
