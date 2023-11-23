//
//  NetworkManager.swift
//

import Foundation

@MainActor
class NetworkManager: ObservableObject {

    // MARK: - Internal Properties

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
