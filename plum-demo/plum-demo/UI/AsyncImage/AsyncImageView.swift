import SwiftUI
import Combine

struct AsyncImageView: View {
    private let image: SwiftUI.State<UIImage>
    private let source: AnyPublisher<UIImage, Never>
    private let contentMode: ContentMode

    init(
        source: AnyPublisher<UIImage, Never>,
        placeholder: UIImage,
        contentMode: ContentMode = .fit
    ) {
        self.source = source
        self.image = SwiftUI.State(initialValue: placeholder)
        self.contentMode = contentMode
    }

    var body: some View {
        return Image(uiImage: image.wrappedValue)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .bind(source, to: image.projectedValue)
    }
}

extension View {
    func bind<P: Publisher, Value>(
        _ publisher: P,
        to state: Binding<Value>
    ) -> some View where P.Failure == Never, P.Output == Value {
        return onReceive(publisher) { value in
            state.wrappedValue = value
        }
    }
}
