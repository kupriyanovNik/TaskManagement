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

            Image(systemName: ImageNames.System.plus)
                .font(.title2.bold())
                .foregroundColor(.black)

        }
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.1, maximumDistance: 50)
                .onEnded { _ in
                    withAnimation {
                        scale = 1.2
                        rotation = 90
                    }
                    delay(0.4) {
                        longAction()
                        delay(0.3) {
                            scale = 1
                            rotation = 0
                        }
                    }
                }
        )
        .highPriorityGesture(
            TapGesture()
                .onEnded { _ in
                    shortAction()
                }
        )
    }
}

#Preview {
    PlusButton(tabBarViewModel: .init(), accentColor: .purple) {
        print("short")
    } longAction: {
        print("long")
    }
}
