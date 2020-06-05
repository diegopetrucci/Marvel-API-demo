import SwiftUI

struct AsyncImageView: View {
    @ObservedObject var viewModel: AsyncImageViewModel
    var contentMode: ContentMode = .fit

    var body: some View {
        image(for: viewModel.state.status)
            .onAppear { self.viewModel.send(event: .onAppear) }
            .onDisappear { self.viewModel.send(event: .onDisappear) }
    }
}

extension AsyncImageView {
    func image(for status: AsyncImageViewModel.Status) -> some View {
        switch status {
        case let .loaded(image: image):
            return Image(uiImage: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        case let .persisted(image: image):
            return Image(uiImage: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        case .failed, .idle, .loading:
            return Image(uiImage: AsyncImageViewModel.placeholder)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(
            viewModel: .fixture()
        )
    }
}