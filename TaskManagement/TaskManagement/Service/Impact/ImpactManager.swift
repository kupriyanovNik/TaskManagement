//
//  ImpactManager.swift
//

import UIKit

final class ImpactManager {

    // MARK: - Inits

    private init() { }

    // MARK: - Internal Functions

    static func generateFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .soft) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
