//
//  NetworkDataModel.swift
//

import Foundation
import FirebaseFirestore

struct NetworkDataModel: Codable, Equatable {
    @DocumentID var id: String?
    
    var title: String
    var description: String
    var isSaveable: Bool
    var imageUrl: String?
    var deadline: Date
}
