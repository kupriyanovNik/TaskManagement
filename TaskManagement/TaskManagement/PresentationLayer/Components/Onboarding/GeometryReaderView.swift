//
//  GeometryReaderView.swift
//

import SwiftUI

struct GeometryReaderView: View {

    // MARK: - Property Wrappers

    @Binding var isExpanded: Bool
    @Binding var startTyping: Bool
    @Binding var showText: Bool

    // MARK: - Internal Properties

    var color: Color
    var text: String = "Next"
    var showNextView: Binding<Bool>?

    var shouldToggleExpand: Bool = true

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(color)
                    .frame(
                        width: isExpanded ? max(geometry.size.width, geometry.size.height) * 1.5 : 200,
                        height: isExpanded ? max(geometry.size.width, geometry.size.height) * 1.5 : 200
                    )

                if !isExpanded {
                    HStack {
                        Text(text)
                            .bold()

                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .offset(
                x: isExpanded ? -250 : 40,
                y: isExpanded ? -150 : 20
            )
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.8)) {
                if shouldToggleExpand {
                    isExpanded.toggle()
                } else {
                    isExpanded = true
                }

                showText.toggle()
                startTyping = true

                if let showNextView {
                    delay(0.1) {
                        showNextView.wrappedValue.toggle()
                    }
                }
            }
        }
    }
}
