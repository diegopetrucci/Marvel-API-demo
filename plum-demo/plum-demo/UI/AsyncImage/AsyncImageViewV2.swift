import SwiftUI

struct AsyncImageViewV2: View {
    @ObservedObject var viewModel: AsyncImageViewModelV2
    var contentMode: ContentMode = .fit

    var body: some View {
        image()
            .onAppear(perform: viewModel.fetch())
            .onDisappear(perform: viewModel.cancel)
    }
}

extension AsyncImageViewV2 {
    func image() -> some View {
        if viewModel.image.isNotNil {
            return AnyView(
                Image(uiImage: viewModel.image!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            )
        } else {
            return AnyView(Text(""))
        }
    }
}
