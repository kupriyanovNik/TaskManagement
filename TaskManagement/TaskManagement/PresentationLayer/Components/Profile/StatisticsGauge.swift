//
//  StatisticsGauge.swift
//

import SwiftUI

struct StatisticsGauge: View {

    // MARK: - Property Wrappers

    @State private var showDetail: Bool = false

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
        VStack {
            if !showDetail {
                Text(title)
                    .hLeading()
                    .padding(.bottom, 5)

                HStack {
                    Text("\(fromValue)/\(toValue)")
                        .padding(.bottom)

                    Spacer()

                    Text("\(percentageString)")
                        .padding(.bottom)
                }
                .font(.caption)
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(accentColor.opacity(isAllDone ? 0.3 : 0.2))

                Circle()
                    .trim(from: 0, to: divided)
                    .stroke(accentColor, lineWidth: 2)
                    .rotationEffect(.degrees(-90))
            }

            Spacer()
        }
        .padding()
        .cornerRadius(cornerRadius)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(accentColor.opacity(0.1))
        }
        .onTapGesture {
            showDetail.toggle()
        }
        .animation(.default, value: showDetail)
    }
}

#Preview {
    StatisticsGauge(
        title: "aaa",
        fromValue: 14,
        toValue: 14,
        accentColor: .purple
    )
    .frame(width: UIScreen.main.bounds.width / 2.5, height: 200)
}
