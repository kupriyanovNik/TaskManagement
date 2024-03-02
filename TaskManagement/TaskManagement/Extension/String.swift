//
//  Color.swift
//

import SwiftUI

// MARK: - For converting 'special' String to Color
extension String {
    func toColor() -> Color {
        switch self {
        case "Card-1":
            return .red
        case "Card-2":
            return .yellow
        case "Card-3":
            return .green
        case "Card-4":
            return .purple
        case "Card-5":
            return .brown
        case "Card-6":
            return .gray
        default:
            return .clear
        }
    }
}

// MARK: - For Removing " " in start of String
extension String {
    func removeLeadingSpacing() -> String {
        var inside = self

        while inside.first == " " {
            inside.removeFirst()
        }

        return inside
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
