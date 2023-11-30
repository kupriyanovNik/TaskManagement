//
//  TabItemButtonStyle.swift
//

import SwiftUI

struct TabItemButtonStyle: ButtonStyle {

    // MARK: Internal Properties

    var isSelected: Bool

    // MARK: - Body

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(isSelected ? 1.15 : 1)
            .opacity(isSelected ? 1 : 0.5)
            .animation(.linear, value: isSelected)
            .shadow(color: .black.opacity(0.4), radius: isSelected ? 10 : 0)
            .animation(.interpolatingSpring, value: isSelected)
    }
}
