import SwiftUI

// To see what was up with the images in the `my squad` view,
// I've tried another approach to download them. Even
// with this one they seem to disappear when coming back
// from the detail view. At this point I believe it's a
// SwiftUI bug, or at the very least a quick of its layout
// system that is not fully clear yet.
struct AsyncImageViewV2: View {
    @ObservedObject var viewModel: AsyncImageViewModelV2
    var contentMode: ContentMode = .fit

    var body: some View {
        image()
            .onAppear(perform: viewModel.fetch)
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
