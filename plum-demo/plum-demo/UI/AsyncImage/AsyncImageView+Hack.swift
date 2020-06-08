import SwiftUI

struct AsyncImageViewHack: View {
    @ObservedObject var viewModel: AsyncImageViewModelHack
    var contentMode: ContentMode = .fit

    var body: some View {
        image(for: viewModel.state.status)
            .onAppear { self.viewModel.send(event: .onAppear) }
            .onDisappear { self.viewModel.send(event: .onDisappear) }
    }
}

extension AsyncImageViewHack {
    func image(for status: AsyncImageViewModelHack.Status) -> some View {
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
                 Text("")
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
