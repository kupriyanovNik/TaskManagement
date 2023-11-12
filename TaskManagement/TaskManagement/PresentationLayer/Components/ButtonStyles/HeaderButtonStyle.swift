//
//  HeaderButtonStyle.swift
//

import SwiftUI

struct HeaderButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .opacity(configuration.isPressed ? 0.75 : 1)
            .animation(.spring, value: configuration.isPressed)
    }
}
