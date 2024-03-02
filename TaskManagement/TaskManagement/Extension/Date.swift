//
//  Date.swift
//

import Foundation
import SwiftUI

// MARK: - For Gettings 'Good Evening'
extension Date {
    /// Function returning a localized string depending on the current time
    func greeting() -> String {
        let strings = Localizable.Greetings.self
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)

        if hour >= 0 && hour < 6 {
            return strings.night
        } else if hour >= 6 && hour < 12 {
            return strings.morning
        } else if hour >= 12 && hour < 18 {
            return strings.day
        } else {
            return strings.evening
        }
    }

    func extract(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        return formatter.string(from: self)
    }
}
