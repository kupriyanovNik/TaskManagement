//
//  CustomNavigationBar.swift
//

import SwiftUI

struct CustomNavBar<Content: View>: View {

    // MARK: - Internal Properties
    var showBackground: Bool
    var backgroundColor: Color
    var content: () -> Content

    // MARK: - Body
    var body: some View {
        self.content()
            .padding(.bottom, 10)
            .background {
                if showBackground {
                    backgroundColor
                        .ignoresSafeArea()
                }
            }
    }
}
