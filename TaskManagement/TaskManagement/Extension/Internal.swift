//
//  Internal.swift
//

import SwiftUI
import Foundation

// MARK: - For Impact Feedback
func generateFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .soft) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

// MARK: - For Delay
func delay(
    _ time: Double,
    execute: @escaping () -> ()
) {
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + time, execute: execute)
}
