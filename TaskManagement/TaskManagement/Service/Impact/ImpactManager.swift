//
//  ImpactManager.swift
//

import UIKit

class ImpactManager {

    // MARK: - Static Properties

    static let shared = ImpactManager()

    // MARK: - Inits

    private init() { }

    // MARK: - Internal Functions

    func generateFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .soft) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

}
