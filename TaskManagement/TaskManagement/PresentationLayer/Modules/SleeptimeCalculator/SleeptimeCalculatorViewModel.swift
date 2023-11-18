//
//  SleeptimeCalculatorViewModel.swift
//

import Foundation

class SleeptimeCalculatorViewModel: ObservableObject {
    
    // MARK: - Property Wrappers

    @Published var hour = 7
    @Published var minutes = 0

    @Published var quizIndex: Int = 0

    @Published var sleepAmount = 8.0
    @Published var coffeeAmount = 1

    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showingAlert = false

    func reset() {
        hour = 7
        minutes = 0
        quizIndex = 0
        alertTitle = ""
        alertMessage = ""
    }

}
