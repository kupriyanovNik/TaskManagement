//
//  CategorySelectorButtonStyle.swift
//

import SwiftUI

struct CategorySelectorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(8)
            .padding(.vertical, 13)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    feedback()
                }
            }
            .animation(.default, value: configuration.isPressed)
    }
}
