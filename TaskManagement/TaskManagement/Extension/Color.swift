//
//  Color.swift
//

import SwiftUI


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

