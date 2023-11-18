//
//  NeuralManager.swift
//

import Foundation
import CoreML

class NeuralManager {
    func calculateBedtime(
        wakeUpTime: Date,
        sleepAmount: Double,
        coffeeAmount: Int = 0,
        userAge: Int,
        onSuccess: (() -> ())? = nil
    ) -> String? {
        do {
            let config = MLModelConfiguration()
            let model = try SleeptimeCalculatorModel(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(
                wake: Int64(Double(hour + minute)),
                estimatedSleep: sleepAmount,
                coffee: Int64(coffeeAmount),
                age: Int64(userAge)
            )

            let sleepTime = wakeUpTime - prediction.actualSleep

            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
            return nil
        }
    }
}
