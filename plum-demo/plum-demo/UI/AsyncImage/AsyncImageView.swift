import SwiftUI
import Combine

struct AsyncImage: View {
    private let image: SwiftUI.State<UIImage>
    private let source: AnyPublisher<UIImage, Never>
    private let animation: Animation?

    init(
        source: AnyPublisher<UIImage, Never>,
        placeholder: UIImage,
        animation: Animation? = nil
    ) {
        self.source = source
        self.image = SwiftUI.State(initialValue: placeholder)
        self.animation = animation
    }

    var body: some View {
        return Image(uiImage: image.wrappedValue)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 300)
            .bind(source, to: image.projectedValue.animation(animation))
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
