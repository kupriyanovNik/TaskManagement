//
//  HomeViewModel.swift
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {

    @Published var currentWeek: [Date] = []
    @Published var currentDay = Date()

    @Published var filteredTasks: [TaskModel]?
    @Published var editTask: TaskModel?

    @Published var isEditing: Bool = false
    @Published var showGreetings: Bool = true

    private var calendar = Calendar.current

    init() {
        fetchCurrentWeek()
    }

    func fetchCurrentWeek() {
        let today = Date()
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        guard let firstWeekDay = week?.start else { return }

        (0...6).forEach {
            if let weekday = calendar.date(byAdding: .day, value: $0, to: firstWeekDay) {
                self.currentWeek.append(weekday)
            }
        }
    }

    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    func isToday(date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: currentDay)
    }

    func isCurrentHour(date: Date) -> Bool {
        return calendar.component(.hour, from: date) == calendar.component(.hour, from: Date()) && calendar.isDateInToday(date)
    }
}
