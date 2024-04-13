//
//  NetworkManager.swift
//

import Firebase
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class NetworkManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published var companyTasks: [NetworkDataModel] = []

    // MARK: - Private Properties

    private let db = Firestore.firestore()
    private let decoder = JSONDecoder()

    // MARK: - Internal Functions 

    func getNews(isInitial: Bool = true) {
        Task {
            if !isInitial {
                companyTasks = []
            }

            let querySnapshot = try await db.collection("qwert32122").getDocuments()
            for document in querySnapshot.documents {
                do {
                    let task = try document.data(as: NetworkDataModel.self)
                    companyTasks.append(task)
                } catch {
                    print("DEBUG: \(error.localizedDescription)")
                }
            }
        }
    }
}
