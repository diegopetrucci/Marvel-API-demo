import SwiftUI

struct PreviousIssueView: View {
    let appearance: Appearance

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(uiImage: appearance.image) // TODO
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(idealWidth: 136, idealHeight: 192)
            Text(appearance.title) // TODO
                .foregroundColor(.white)
                .font(Font.system(size: 13))
                .fontWeight(.semibold)
        }
    }
}

struct PreviousIssueView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousIssueView(
            appearance: Appearance(
                image: UIImage(named: "a_bomb_header")!,
                title: "Hulk (2008) #55"
            )
        )
            .background(Color(red: 34 / 255, green: 37 / 255, blue: 43 / 255))
    }
}
