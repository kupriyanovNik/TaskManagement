//
//  SecondOnboardingView.swift
//

import SwiftUI

struct SecondOnboardingView: View {

    // MARK: - Property Wrappers

    @Binding var showNextView: Bool

    @State var isExpanded: Bool = false
    @State var startTyping: Bool = false
    @State var showText: Bool = false

    // MARK: - Private Properties

    private let screenSize = UIScreen.main.bounds

    // MARK: - Body

    var body: some View {
        ZStack {
            GeometryReaderView(
                isExpanded: $isExpanded,
                startTyping: $startTyping,
                showText: $showText,
                color: .cyan,
                text: "Далее",
                showNextView: $showNextView
            )

            VStack(alignment: .leading) {
                Text("Управляйте своим временем\nэффективно")
                    .font(.largeTitle)
                    .bold()

                TypingEffectView(
                    isExpanded: $isExpanded,
                    fullText: """
                    Создавайте задачи, отслеживайте их
                    выполнение и повышайте 
                    продуктивность с нашим
                    интуитивно понятным
                    трекером задач и привычек.
                    """
                )
            }
            .opacity(isExpanded ? 1 : 0)
            .scaleEffect(isExpanded ? 1.05 : 0)
            .offset(x: isExpanded ? 0 : screenSize.width)
        }
        .ignoresSafeArea()
    }
}
