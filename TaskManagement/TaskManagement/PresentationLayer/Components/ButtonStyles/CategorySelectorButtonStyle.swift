//
//  CategorySelectorButtonStyle.swift
//

import SwiftUI

struct CategorySelectorButtonStyle: ButtonStyle {

    // MARK: - Internal Properties

    var pressedScale: Double = 1.2

    // MARK: - Body

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(8)
            .padding(.vertical, 13)
            .scaleEffect(configuration.isPressed ? pressedScale : 1)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    ImpactManager.shared.generateFeedback()
                }
            }
            .animation(.default, value: configuration.isPressed)
    }
}
