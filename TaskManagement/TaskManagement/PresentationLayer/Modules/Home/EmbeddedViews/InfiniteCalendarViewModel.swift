//
//  InfiniteCalendarViewModel.swift
//  TaskManagement
//
//  Created by Никита Куприянов on 01.08.2024.
//

import Foundation
import SwiftUI

class InfiniteCalendarViewModel: ObservableObject {
    @Published var weeks: [WeekModel] = []
    @Published var selectedDate: Date {
        didSet {
            insertWeeks(with: selectedDate)
        }
    }

    private let calendar = Calendar.current

    init(with date: Date = .now) {
        self.selectedDate = calendar.startOfDay(for: date)
        insertWeeks(with: selectedDate)
    }

    func selectToday() {
        select(date: .now)
    }

    func select(date: Date) {
        withAnimation {
            selectedDate = calendar.startOfDay(for: date)
        }
    }

    func update(to direction: TimeDirection) {
        switch direction {
        case .future:
            selectedDate = calendar.date(byAdding: .day, value: 7, to: selectedDate)!

        case .past:
            selectedDate = calendar.date(byAdding: .day, value: -7, to: selectedDate)!

        case .unknown:
            selectedDate = selectedDate
        }

        insertWeeks(with: selectedDate)
    }

    private func insertWeeks(with date: Date) {
        weeks = [
            getWeek(for: calendar.date(byAdding: .day, value: -7, to: date)!, with: -1),
            getWeek(for: date, with: 0),
            getWeek(for: calendar.date(byAdding: .day, value: 7, to: date)!, with: 1)
        ]
    }

    private func getWeek(for date: Date, with index: Int) -> WeekModel {
        var result: [Date] = []

        guard
            let startOfWeek = calendar.date(
                from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
            )
        else { return .init(index: index, dates: [], referenceDate: date) }

        (0...6).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: startOfWeek) {
                result.append(weekday)
            }
        }

        return .init(index: index, dates: result, referenceDate: date)
    }
}
