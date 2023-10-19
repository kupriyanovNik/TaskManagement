//
//  AnimatedGradient.swift
//

import SwiftUI

struct AnimatedGradient: View {

    // MARK: - Property Wrappers

    @State private var start = UnitPoint(x: 0, y: 0)
    @State private var end = UnitPoint(x: 0, y: 2)

    // MARK: - Internal Properties

    let colors: [Color]
    let opacity: Double = 0.3

    // MARK: - Inits

    init(colors: [Color]) {
        self.colors = colors
    }

    init() {
        let allColors: [Color] = [.cyan, .green, .indigo, .mint, .yellow, .red, .purple]
        var randomColors: [Color] = []
        for _ in 0..<3 {
            randomColors.append(allColors.randomElement() ?? .clear)
        }
        self.colors = randomColors
    }

    // MARK: - Body
    
    var body: some View {
        LinearGradient(colors: colors, startPoint: start, endPoint: end)
            .opacity(opacity)
            .ignoresSafeArea()
            .onAppear {
                withAnimation (.easeInOut(duration: 5).repeatForever()) {
                    self.start = .init(x: 1, y: -1)
                    self.end = .init(x: 0, y: 1)
                }
            }
    }
}
