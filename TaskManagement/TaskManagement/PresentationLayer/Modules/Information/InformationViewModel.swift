//
//  InformationViewModel.swift
//

import Foundation

class InformationViewModel: ObservableObject {
    
    // MARK: - Property Wrappers

    @Published var showInformation: Bool = false
    @Published var showDeveloper: Bool = true 
}
