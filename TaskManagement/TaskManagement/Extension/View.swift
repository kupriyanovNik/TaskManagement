//
//  View.swift
//

import SwiftUI

// MARK: - Layout Functions
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

    /// unused
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        return safeArea
    }
}

// MARK: - Navigation Bar Functions
extension View {
    func makeCustomNavBar<Content: View>(
        showBackground: Bool = true,
        backgroundColor: Color = .white,
        content: @escaping () -> Content
    ) -> some View {
        self.safeAreaInset(edge: .top) {
            CustomNavBar(showBackground: showBackground, backgroundColor: backgroundColor) {
                content()
            }
        }
    }
}

// MARK: - Text Field Functions
extension View {
    func endEditing() -> some View {
        onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder), 
                to: nil,
                from: nil,
                for: nil
            )
        }
    }

    func continueEditing() -> some View {
        onTapGesture {}
    }
}
