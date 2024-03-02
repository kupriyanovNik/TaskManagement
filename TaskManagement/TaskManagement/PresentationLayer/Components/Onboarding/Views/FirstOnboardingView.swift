//
//  FirstOnboardingView.swift
//

import SwiftUI

struct FirstOnboardingView: View {

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
                color: .orange,
                text: "Начать",
                showNextView: $showNextView
            )

            VStack(alignment: .leading) {
                Text("Добро пожаловать!")
                    .font(.largeTitle)
                    .bold()

                TypingEffectView(
                    isExpanded: $isExpanded,
                    fullText: """
                    Мы поможем Вам управлять
                    задачами и формировать
                    полезные привычки
                    с помощью передовых технологий
                    и нейронных сетей.
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
