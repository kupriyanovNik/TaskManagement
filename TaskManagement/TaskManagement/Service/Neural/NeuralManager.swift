//
//  NeuralManager.swift
//

import Foundation
import CoreML

class NeuralManager {

    // MARK: - Static Properties

    static let shared = NeuralManager()

    // MARK: - Internal Functions

    @discardableResult
    func calculateBedtime(
        hour: Int,
        minute: Int,
        sleepAmount: Double,
        coffeeAmount: Int = 0,
        userAge: Int,
        onSuccess: (() -> ())? = nil
    ) -> String? {
        do {
            let config = MLModelConfiguration()
            let model = try SleeptimeCalculatorModel(configuration: config)

            let prediction = try model.prediction(
                wake: Int64(Double(hour + minute)),
                estimatedSleep: sleepAmount,
                coffee: Int64(10 - 2 * coffeeAmount),
                age: Int64(userAge)
            )

            var components = DateComponents()
            components.hour = hour
            components.minute = minute

            let sleepTime = (Calendar.current.date(from: components) ?? Date.now) - prediction.actualSleep

            return sleepTime.formatted(date: .omitted, time: .shortened)

        } catch {
            print("DEBUG: \(error.localizedDescription)")

            return nil
        }
    }
}

