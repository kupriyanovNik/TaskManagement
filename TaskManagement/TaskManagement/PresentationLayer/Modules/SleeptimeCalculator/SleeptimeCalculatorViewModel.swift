//
//  SleeptimeCalculatorViewModel.swift
//

import Foundation

class SleeptimeCalculatorViewModel: ObservableObject {
    
    // MARK: - Property Wrappers

    @Published var hour = 12
    @Published var minutes = 0

    @Published var symbol = "AM"

    @Published var sleepAmount = 8.0
    @Published var coffeeAmount = 1

    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showingAlert = false

}
