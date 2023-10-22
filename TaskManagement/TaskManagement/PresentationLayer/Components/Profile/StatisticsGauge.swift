//
//  StatisticsGauge.swift
//

import SwiftUI

struct StatisticsGauge: View {

    // MARK: - Property Wrappers

    @State private var showDetail: Bool = false
    @State private var isAppeared: Bool = false
    @State private var lineWidth: Double = 5

    // MARK: - Internal Properties
    
    var title: String
    var fromValue: Int
    var toValue: Int
    var accentColor: Color
    var cornerRadius: Double = 10

    // MARK: - Private Properties

    private var divided: Double {
        if !isAppeared { return 0 }
        return Double(fromValue) / Double(toValue)
    }

    private var percentage: Double {
        divided * 100
    }

    private var percentageString: String {
        String(format: "%.0f", percentage) + "%"
    }

    private var isAllDone: Bool {
        percentage == 100
    }

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("\(fromValue)/\(toValue)")
                    .font(.title)
                    .foregroundColor(accentColor)
                    .fontWeight(.bold)
                    .opacity(showDetail ? 0.5 : 1)
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(accentColor.opacity(isAllDone ? 0.3 : 0.2))

                Circle()
                    .trim(from: 0, to: divided)
                    .stroke(
                        accentColor,
                        style: .init(
                            lineWidth: lineWidth / (showDetail ? 1.5 : 1),
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))

                if showDetail {
                    Text("\(percentageString)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(accentColor)
                }
            }
            .padding()
            .frame(width: 170, height: 170)

        }
        .padding()
        .background {
            RoundedRectangle(
                cornerRadius: cornerRadius + (showDetail ? 10 : 0)
            )
            .fill(accentColor.opacity(0.2))
        }
        .onAppear {
            whenStarted()
        }
        .animation(.linear, value: lineWidth)
        .animation(.linear, value: showDetail)
        .animation(.linear, value: isAppeared)
        .onTapGesture {
            if fromValue != 0 {
                showDetail.toggle()
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Private Functions

    private func whenStarted() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isAppeared = true

            lineWidth = 15

            if fromValue == 0 {
                showDetail = true
            }

            if isAllDone {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    lineWidth = 5

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        lineWidth = 15
                    }
                }
            }
        }
    }
}

#Preview {
    StatisticsGauge(
        title: "Today Done Tasks",
        fromValue: 3,
        toValue: 10,
        accentColor: .purple
    )
}
