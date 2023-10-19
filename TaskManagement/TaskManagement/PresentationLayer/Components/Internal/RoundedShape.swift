//
//  RoundedShape.swift
//

import SwiftUI

struct RoundedShape: Shape {

    // MARK: - Internal Properties

    let corners: UIRectCorner
    var radius: CGFloat = 10

    // MARK: - Path

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
