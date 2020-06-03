import SwiftUI

struct MySquadView: View {
    let members: [Superhero]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Squad")
                .foregroundColor(.white)
                .font(Font.system(size: 20))
                .fontWeight(.semibold)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(members, id: \.self) { member in
                        VStack(spacing: 4) {
                            Image(uiImage: member.image)
                                .resizable()
                                .frame(width: 64, height: 64)
                                .clipShape(Circle())
                            Text(member.name)
                                .foregroundColor(.white)
                                .font(Font.system(size: 13))
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                            // I've chosen here not to set a maxmium width
                            // to avoid problems when the user has
                            // set a bigger text size
                            .frame(idealWidth: 64)
                    }
                }
            }
        }
    }
}

struct MySquadView_Previews: PreviewProvider {
    static var previews: some View {
        MySquadView(
            members: [
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture(),
                Superhero.fixture()
            ]
        )
            .background(Color(red: 54 / 255, green: 59 / 255, blue: 69 / 255))
    }
}
