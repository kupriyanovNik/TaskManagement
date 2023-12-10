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
                color: .brown,
                text: "Start",
                showNextView: $showNextView
            )

            VStack(alignment: .leading) {
                Text("gfksnkgnasf\ndsfgsd")
                    .font(.largeTitle)
                    .bold()

                TypingEffectView(
                    isExpanded: $isExpanded,
                    fullText: """
                    meow meow meow meow meow
                    meow meow meow 
                    fagjafdnjgndf
                    sfagdjknaskjdngksfgde
                    sadgasfgefqgrg
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
