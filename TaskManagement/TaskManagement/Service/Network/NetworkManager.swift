//
//  NetworkManager.swift
//

import SwiftUI
import Firebase
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class NetworkManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published var companyTasks: [NetworkDataModel] = []

    @AppStorage(
        UserDefaultsConstants.selectedCompanyId.rawValue
    ) var selectedCompanyId: String = ""

    // MARK: - Private Properties

    private let db = Firestore.firestore()

    // MARK: - Internal Functions 

    func getNews(isInitial: Bool = true) {
        Task {
            if !isInitial {
                companyTasks = []
            }

            let querySnapshot = try await db.collection(selectedCompanyId).getDocuments()

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
