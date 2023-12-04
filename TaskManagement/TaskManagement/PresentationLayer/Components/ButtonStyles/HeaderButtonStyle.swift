//
//  HeaderButtonStyle.swift
//

import SwiftUI

struct HeaderButtonStyle: ButtonStyle {

    // MARK: Internal Properties

    var pressedScale: Double = 1.1
    var pressedOpacity: Double = 0.85

    // MARK: - Body

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1)
            .opacity(configuration.isPressed ? pressedOpacity : 1)
            .animation(.spring, value: configuration.isPressed)
    }
}
