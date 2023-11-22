//
//  CustomTextFiel.swift
//

import SwiftUI

struct CustomTextField: View {

    // MARK: - Embedded

    enum CustomTextFieldStyle {
        case underlined, stroked
    }

    // MARK: - Property Wrappers

    @Binding var inputText: String
    @FocusState var isFocused: Bool

    // MARK: - Internal Properties

    var customTextFieldStyle: CustomTextFieldStyle = .underlined
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
        .background {
            if customTextFieldStyle == .stroked {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                strokeColor,
                                lineWidth: withBorder ? 1 : 0
                            )
                    }
                    .shadow(
                        color: strokeColor.opacity(0.3),
                        radius: isFocused ? 4 : 0
                    )
            } else if customTextFieldStyle == .underlined {
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isFocused ? strokeColor : strokeColor.opacity(0.2))
                        .frame(height: 3)
                }
            }
        }
        .animation(.linear, value: isFocused)
    }
}

// MARK: - Preview

#Preview {
    CustomTextField(
        inputText: .constant("Hello"),
        customTextFieldStyle: .underlined,
        placeHolder: "Meow",
        backgroundColor: .white,
        strokeColor: .black,
        shouldExpandVertically: false
    )
    .padding()
}
