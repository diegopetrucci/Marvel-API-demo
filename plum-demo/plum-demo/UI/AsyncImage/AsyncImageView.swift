import SwiftUI
import Combine

struct AsyncImageView: View {
    private let image: SwiftUI.State<UIImage>
    private let sourcePublisher: AnyPublisher<UIImage, Never>
    private let contentMode: ContentMode

    init(
        sourcePublisher: AnyPublisher<UIImage, Never>,
        placeholder: UIImage,
        contentMode: ContentMode = .fit
    ) {
        self.sourcePublisher = sourcePublisher
        self.image = SwiftUI.State(initialValue: placeholder)
        self.contentMode = contentMode
    }

    var body: some View {
        return Image(uiImage: image.wrappedValue)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .onReceive(sourcePublisher, perform: { self.image.projectedValue.wrappedValue = $0 })
    }
}
