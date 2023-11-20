//
//  SleeptimeCalculatorViewModel.swift
//

import Foundation

class SleeptimeCalculatorViewModel: ObservableObject {
    
    // MARK: - Property Wrappers

    @Published var selectedWakeUpTime: Date = .now

    @Published var quizIndex: Int = 0

    @Published var sleepAmount = 8.0
    @Published var coffeeAmount = 1

    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showingAlert = false

    func reset() {
        selectedWakeUpTime = .now
        alertTitle = ""
        alertMessage = ""
    }

}
