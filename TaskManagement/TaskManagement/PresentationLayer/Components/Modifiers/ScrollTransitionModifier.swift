//
//  ScrollTransitionModifier.swift
//

import SwiftUI

struct ScrollTransitionModifier: ViewModifier {

    // MARK: - Internal Properties

    var condition: Bool

    // MARK: - Body

    func body(content: Content) -> some View {
        if #available(iOS 17, *), condition {
            content
                .scrollTransition(.animated(.bouncy)) { effect, phase in
                    effect
                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                        .opacity(phase.isIdentity ? 1 : 0.8)
                        .blur(radius: phase.isIdentity ? 0 : 2)
                        .brightness(phase.isIdentity ? 0 : 0.3)
                }
        } else {
            content
        }
    }
}
