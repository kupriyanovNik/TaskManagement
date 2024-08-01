//
//  WeekView.swift
//  TaskManagement
//
//  Created by Никита Куприянов on 01.08.2024.
//

import SwiftUI

struct WeekView: View {
    @ObservedObject var infiniteCalendarViewModel: InfiniteCalendarViewModel

    var week: WeekModel

    private var cellWidth: CGFloat {
        UIScreen.main.bounds.width / 7.2
    }

    @Namespace private var animtion

    var body: some View {
        HStack {
            ForEach(0..<7) { item in
                content(with: item)
                    .animation(
                        .none,
                        value: infiniteCalendarViewModel.selectedDate
                    )
            }
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func content(with index: Int) -> some View {
        let isSelected = Calendar.current.isDate(
            infiniteCalendarViewModel.selectedDate,
            inSameDayAs: week.dates[index]
        )

        VStack(spacing: 3) {
            Text(
                week.dates[index].toString(format: "EEE")
                    .prefix(2)
                    .uppercased()
            )

            Text(week.dates[index].toString(format: "d"))
                .padding(10)
        }
        .animation(.none, value: infiniteCalendarViewModel.selectedDate)
        .foregroundStyle(isSelected ? .white : .black)
        .font(.body)
        .padding(.top, 10)
        .hCenter()
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.black)
                    .matchedGeometryEffect(id: "SelectedDate", in: animtion)
            }
        }
        .animation(.linear(duration: 0.2), value: infiniteCalendarViewModel.selectedDate)
        .hCenter()
        .onTapGesture {
            select(at: index)
        }
    }

    private func select(at index: Int) {
        infiniteCalendarViewModel.select(date: week.dates[index])
    }

    private func isSelected(at index: Int) -> Bool {
        week.dates[index] == week.referenceDate
    }
}
