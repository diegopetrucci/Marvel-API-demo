import SwiftUI

struct HeroDescriptionView: View {
   let superhero: Superhero

    var body: some View {
        VStack(spacing: 16) {
            Text(superhero.name)
                .foregroundColor(.white)
                .font(Font.system(size: 34))
                .fontWeight(.bold)
                .alignmentGuide(.leading) { d in d[.leading] } // TODO: this is not working
            Button(
                action: { }, // TODO
                label: {
                    Text("💪 Recruit to Squad")
                        .foregroundColor(.white)
                        .font(Font.system(size: 17))
                        .fontWeight(.semibold)
                }
            )
                // `idealWidth` and `idealHeight` here make the button wrap the text, similar to required content hugging
                .frame(width: 288, height: 43)
                .background(Color(red: 243 / 255, green: 12 / 255, blue: 11 / 255))
                .cornerRadius(5)
                .shadow(radius: 10)
            Text(superhero.description)
                .foregroundColor(.white)
                .font(Font.system(size: 17))
                .fontWeight(.regular)
                .alignmentGuide(.leading) { d in d[.leading] }
        }
    }
}

struct HeroDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        HeroDescriptionView(superhero: .fixture())
            .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255))
    }
}
