//
//  ShowOnboardingViewAnimated.swift
//

import SwiftUI

struct ShowOnboardingViewAnimated: ViewModifier {

    // MARK: - Internal Properties

    var shouldShow: Bool

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .offset(x: shouldShow ? 0 : 200)
            .scaleEffect(shouldShow ? 1 : 0, anchor: .bottomTrailing)
            .animation(.smooth, value: shouldShow)
    }
}
