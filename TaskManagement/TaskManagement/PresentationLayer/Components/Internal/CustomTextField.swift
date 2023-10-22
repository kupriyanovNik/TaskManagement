//
//  CustomTextFiel.swift
//

import SwiftUI

struct CustomTextField: View {

    // MARK: - Property Wrappers

    @Binding var inputText: String
    @FocusState var isFocused: Bool

    // MARK: - Internal Properties

    var placeHolder: String
    var cornerRadius: CGFloat = 10
    var backgroundColor: Color = .white
    var strokeColor: Color = .black
    var withBorder: Bool = true
    var shouldExpandVertically: Bool = true

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .trailing) {
            if #available(iOS 16, *), shouldExpandVertically {
                TextField(placeHolder, text: $inputText, axis: .vertical)
            } else {
                TextField(placeHolder, text: $inputText)
            }
        }
        .focused($isFocused)
        .foregroundColor(Color.black)
        .disableAutocorrection(true)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            strokeColor, 
                            lineWidth: withBorder ? 1 : 0
                        )
                )
                .shadow(radius: isFocused ? 4 : 0)
                .animation(.linear, value: isFocused)
        )
    }
}
