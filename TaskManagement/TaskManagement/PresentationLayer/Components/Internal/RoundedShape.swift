//
//  RoundedShape.swift
//

import SwiftUI

struct RoundedShape: Shape {
    let corners: UIRectCorner
    var radius: CGFloat = 10
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
