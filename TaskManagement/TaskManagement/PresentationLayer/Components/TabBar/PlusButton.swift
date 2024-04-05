//
//  PlusButton.swift
//

import SwiftUI

struct PlusButton: View {

    // MARK: - Property Wrappers

    @ObservedObject var tabBarViewModel: TabBarViewModel

    @State private var scale: Double = 1
    @State private var rotation: Double = 0

    // MARK: - Internal Properties

    var accentColor: Color

    var shortAction: () -> ()
    var longAction: () -> ()

    // MARK: - Body

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            .pink, .indigo,
                            accentColor,
                            .purple, .mint
                        ],
                        startPoint: tabBarViewModel.gradientStart,
                        endPoint: tabBarViewModel.gradientEnd
                    ), style: .init(lineWidth: tabBarViewModel.gradientLineWidth)
                )
                .shadow(color: accentColor.opacity(0.5), radius: 10)
                .rotationEffect(.degrees(tabBarViewModel.gradientRotation))
                .frame(width: 48)

            Image(systemName: ImageConstants.System.plus)
                .font(.title2.bold())
                .foregroundColor(.black)

        }
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
        .onLongPressGesture(minimumDuration: 0.2, maximumDistance: 50) {
            longAction()

            ImpactManager.generateFeedback(style: .soft)

            delay(0.3) {
                scale = 1
                rotation = 0
                tabBarViewModel.gradientLineWidth = 5
            }
        } onPressingChanged: { isPressed in
            withAnimation(.linear) {
                rotation = isPressed ? 90 : 0
                tabBarViewModel.gradientLineWidth = isPressed ? 6 : 5
                scale = isPressed ? 1.1 : 1
            }
        }
        .highPriorityGesture(
            TapGesture()
                .onEnded { _ in
                    shortAction()
                }
        )
    }
}

// MARK: - Preview

#Preview {
    PlusButton(tabBarViewModel: .init(), accentColor: .purple) {
        print("short")
    } longAction: {
        print("long")
    }
}
