import Combine
import UIKit

final class AsyncImageViewModelV2: ObservableObject {
    @Published var image: UIImage?
    private(set) var isLoading = false
    private let imageProcessingQueue = DispatchQueue(label: "image-processing")
    private let url: URL
    private var cancellable: AnyCancellable?

    init(url: URL) {
        self.url = url
    }

    deinit {
        cancellable = nil
    }

    func fetch() {
        print(isLoading)
        guard !isLoading else { return }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: imageProcessingQueue)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { _ in },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    private func onStart() {
        isLoading = true
    }

    private func onFinish() {
        isLoading = false
    }

    func cancel() {
        cancellable?.cancel()
    }
}
