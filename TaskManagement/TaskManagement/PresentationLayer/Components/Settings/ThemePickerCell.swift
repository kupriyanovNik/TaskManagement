//
//  ThemePickerCell.swift
//  

import SwiftUI

struct ThemePickerCell: View {

    // MARK: - Internal Properties

    var accentColor: Color
    var pageTitleColor: Color
    var themeName: String
    var onSelect: () -> ()

    // MARK: - Body

    var body: some View {
        VStack {
            Text(themeName)
                .font(.caption)

            HStack(spacing: 0) {
                accentColor
                pageTitleColor
            }
            .frame(width: 100, height: 60)
            .cornerRadius(10)
            .onTapGesture {
                onSelect()
            }
        }
    }
}
