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
        case let .loaded(image):
            return AnyView(
                Image(uiImage: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: contentMode)
            )
        case let .persisted(image):
            return AnyView(
             Image(uiImage: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: contentMode)
            )
        case .idle, .loading:
            return AnyView(
                // I would have preferred an EmptyView, but SwiftUI completely
                // stops loading if we add that
                Image(uiImage: AsyncImageViewModel.placeholder)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            )
        case .failed:
            return AnyView(
                Text("Failed to load, tap to retry.")
                    .foregroundColor(Colors.text)
                    .font(Font.system(size: 17))
                    .fontWeight(.semibold)
            )
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        let provider = ImageProvider(
            api: MarvelAPI(remote: Remote()),
            persister: ImagePersister()
        ).imageDataProvidingFixture(false)(URL.fixture())

        return AsyncImageView(
            viewModel:
            .init(
                url: .fixture(),
                dataProvider: provider
            )
        )
    }
}
