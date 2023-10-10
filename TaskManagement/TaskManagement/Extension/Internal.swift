//
//  Internal.swift
//

import SwiftUI

func feedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .soft) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}
