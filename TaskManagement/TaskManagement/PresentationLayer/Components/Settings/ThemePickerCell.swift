//
//  ThemePickerCell.swift
//

import SwiftUI

struct ThemePickerCell: View {

    // MARK: - Internal Properties

    var theme: ThemeProtocol
    var isSelected: Bool
    var onSelect: () -> ()

    // MARK: - Body

    var body: some View {
        Button {
            onSelect()
        } label: {
            VStack {
                Circle()
                    .fill(theme.pageTitleColor)
                    .frame(width: 20, height: 20)
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(theme.pageTitleColor)
                    .frame(width: 50, height: 6)

                VStack(spacing: 5) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .frame(width: 38, height: 6)
                            .opacity(isSelected ? 1 : 0.7)
                    }
                }
                .foregroundStyle(theme.accentColor)
                .frame(width: 50, height: 50)
                .background(
                    .white,
                    in: RoundedRectangle(cornerRadius: 5)
                )
            }
            .padding(8)
            .background(
                theme.accentColor
                    .opacity(isSelected ? 0.6 : 0.4),
                in: RoundedRectangle(cornerRadius: 5)
            )
            .animation(.default, value: isSelected)
            .scaleEffect(isSelected ? 1.05 : 1)
        }
        .buttonStyle(HeaderButtonStyle(pressedScale: 1.1, pressedOpacity: 1))
        .animation(
            .smooth(extraBounce: 0.5),
            value: isSelected
        )
    }
}

#Preview {
    ThemePickerCell(theme: Theme2(), isSelected: true) {

    }
}
