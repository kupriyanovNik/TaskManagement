//
//  View.swift
//

import SwiftUI

extension View {
    func hLeading() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
    }
    func hTrailing() -> some View {
        frame(maxWidth: .infinity, alignment: .trailing)
    }
    func hCenter() -> some View {
        frame(maxWidth: .infinity, alignment: .center)
    }
    func getSafeArea() -> UIEdgeInsets {
        guard
            let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { return .zero }
        guard
            let safeArea = screen.windows.first?.safeAreaInsets
        else { return .zero }
        return safeArea
    }
}


extension View {
    func makeCustomNavBar<Content: View>(showBackground: Bool = true, backgroundColor: Color = .white, content: @escaping () -> Content) -> some View {
        self.safeAreaInset(edge: .top) {
            CustomNavBar(showBackground: showBackground, backgroundColor: .white) {
                content()
            }
        }
    }
}

