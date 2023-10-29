//
//  CirclePlusButtonStyle.swift
//

import SwiftUI

struct CirclePlusButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(1)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .rotationEffect(.degrees(configuration.isPressed ? 90 : 0))
            .animation(.spring, value: configuration.isPressed)
    }
}

#Preview {
    Button {

    } label: {
        Image(systemName: "plus")
            .foregroundColor(.black)
    }

}
