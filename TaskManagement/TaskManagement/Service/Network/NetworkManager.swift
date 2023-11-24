//
//  NetworkManager.swift
//

import Foundation

@MainActor
class NetworkManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published var news: [SpaceNewsModel] = []

    // MARK: - Internal Functions 

    func getNews() {
        Task {
            do {
                news = try await DataProvider.fetchData(Requests.GetNews())
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
}
