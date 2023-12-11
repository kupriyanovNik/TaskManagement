//
//  TypingEffectView.swift
//

import SwiftUI

struct TypingEffectView: View {

    // MARK: - Property Wrappers

    @State private var displayedText: String = ""
    @State private var currentCharacterIndex: String.Index!

    @Binding var isExpanded: Bool

    // MARK: - Internal Properties

    var fullText: String

    // MARK: - Body

    var body: some View {
        VStack {
            Text(displayedText)
                .font(.headline)
                .foregroundColor(.black)
                .frame(
                    width: 350,
                    height: 150,
                    alignment: .topLeading
                )
        }
        .onChange(of: isExpanded) { newValue in
            if newValue {
                startTypingEffect()
            }
        }
    }

    // MARK: - Private Functions

    private func startTypingEffect() {
        displayedText = ""
        
        delay(0.5) {
            currentCharacterIndex = fullText.startIndex

            if var currentCharacterIndex {
                Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                    displayedText.append(
                        fullText[currentCharacterIndex]
                    )

                    currentCharacterIndex = fullText.index(
                        after: currentCharacterIndex
                    )

                    if currentCharacterIndex == fullText.endIndex {
                        timer.invalidate()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TypingEffectView(
        isExpanded: .constant(false),
        fullText: """
        meow meow meow meow meow meow meow meow meow
        meow meow meow meow meow meow meow
        meow meow meow meow meow meow meow meow meow
        """
    )
}
