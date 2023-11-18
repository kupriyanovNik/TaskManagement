//
//  SleeptimeCalculatorViewModel.swift
//

import Foundation

class SleeptimeCalculatorViewModel: ObservableObject {
    
    // MARK: - Property Wrappers

    @Published var wakeUp = defaultWakeTime
    @Published var sleepAmount = 8.0
    @Published var coffeeAmount = 1

    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showingAlert = false

    // MARK: - Static Properties

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0

        return Calendar.current.date(from: components) ?? Date.now
    }
}
