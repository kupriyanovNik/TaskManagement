//
//  RadioButton.swift
//

import SwiftUI

struct RadioButton: View {

    // MARK: - Property Wrappers

    @Binding var isSelected: Bool

    // MARK: - Internal Properties

    var accentColor: Color

    // MARK: - Body

    var body: some View {
        ZStack {
            Circle()
                .stroke(accentColor, style: .init(lineWidth: 2))
            
            if isSelected {
                Circle()
                    .fill(accentColor)
                    .padding(2)
                    .overlay {
                        Image(systemName: ImageConstants.System.checkmark)
                            .foregroundColor(.white)
                    }
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .onTapGesture {
            ImpactManager.generateFeedback(style: .medium)
            
            isSelected.toggle()
        }
        .animation(.default, value: isSelected)
    }
}

// MARK: - Preview

#Preview {
    RadioButton(
        isSelected: .constant(true),
        accentColor: .purple
    )
    .frame(width: 30, height: 30)
}
