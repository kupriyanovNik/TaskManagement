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

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeHolder.capitalized)
                .padding(.leading)
                .foregroundColor(.gray)
            ZStack(alignment: .trailing) {
                TextField(placeHolder, text: $inputText)
            }
            .focused($isFocused)
            .foregroundColor(Color.black)
            .disableAutocorrection(true)
            .frame(maxHeight: 24)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(strokeColor, lineWidth: withBorder ? 1 : 0)
                    )
                    .shadow(radius: isFocused ? 4 : 0)
                    .animation(.linear, value: isFocused)
            )
        }
    }
}
