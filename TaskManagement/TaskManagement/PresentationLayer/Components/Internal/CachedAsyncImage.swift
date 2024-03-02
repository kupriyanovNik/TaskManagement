//
//  CachedAsyncImage.swift
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {

    // MARK: - Property Wrappers

    @State private var image: UIImage?
    @State private var error: String?

    // MARK: - Internal Properties

    var imageUrlString: String
    var content: (UIImage) -> Content
    var placeholder: () -> Placeholder
    var showAnimated: Bool = true

    // MARK: - Private Properties

    private let urlCache = URLCache.shared
    private let urlSession = URLSession.shared

    // MARK: - Body

    var body: some View {
        if let image {
            content(image)
        } else {
            placeholder()
                .onAppear {
                    loadImage()
                }
        }
    }

    // MARK: - Private Functions

    private func loadImage() {
        guard let url = URL(string: imageUrlString) else { return }

        let urlRequest = URLRequest(url: url)

        if let cachedResponse = urlCache.cachedResponse(for: urlRequest),
            let image = UIImage(data: cachedResponse.data) {
            self.image = image
        } else {
            urlSession.dataTask(with: urlRequest) { data, response, error in
                handleError(error)

                if let data, let response, let image = UIImage(data: data) {
                    storeCache(response: response, data: data, request: urlRequest)

                    DispatchQueue.main.async {
                        withAnimation(.linear(duration: showAnimated ? 0.3 : 0)) {
                            self.image = image
                        }
                    }
                }
            }.resume()
        }
    }

    private func handleError(_ error: Error?) {
        guard error == nil else {
            self.error = error?.localizedDescription ?? ""
            print("DEBUG: \(error?.localizedDescription ?? "")")

            return
        }
    }

    private func storeCache(
        response: URLResponse,
        data: Data,
        request: URLRequest
    ) {
        let cachedResponse = CachedURLResponse(response: response, data: data)
        urlCache.storeCachedResponse(cachedResponse, for: request)
    }
}
