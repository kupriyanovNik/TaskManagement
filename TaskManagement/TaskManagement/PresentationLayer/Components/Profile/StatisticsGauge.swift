//
//  StatisticsGauge.swift
//

import SwiftUI

struct StatisticsGauge: View {

    // MARK: - Property Wrappers

    @State private var showDetail: Bool = false
    @State private var lineWidth: Double = 5

    // MARK: - Internal Properties
    
    var title: String
    var fromValue: Int
    var toValue: Int
    var accentColor: Color
    var cornerRadius: Double = 10

    // MARK: - Private Properties

    private var divided: Double {
        Double(fromValue) / Double(toValue)
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
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(accentColor.opacity(isAllDone ? 0.3 : 0.2))

                Circle()
                    .trim(from: 0, to: divided)
                    .stroke(accentColor, style: .init(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                if showDetail {
                    Text("\(percentageString)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(accentColor)
                }
            }
            .padding()

            Spacer()
        }
        .padding()
        .cornerRadius(cornerRadius)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(accentColor.opacity(0.2))
        }
        .onAppear {
            lineWidth = 15
            if fromValue == 0 {
                showDetail = true 
            }
            if isAllDone {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    lineWidth = 45
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        lineWidth = 15
                    }
                }
            }
        }
        .animation(.linear, value: lineWidth)
        .animation(.linear, value: showDetail)
        .onTapGesture {
            showDetail.toggle()
        }
        .padding(.horizontal)
    }
}

#Preview {
    StatisticsGauge(
        title: "Today Tasks",
        fromValue: 3,
        toValue: 10,
        accentColor: .purple
    )
}
