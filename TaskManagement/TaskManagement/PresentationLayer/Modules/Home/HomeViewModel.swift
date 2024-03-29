//
//  HomeViewModel.swift
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showCalendar: Bool = true 
    @Published var showHeaderTap: Bool = false

    @Published var currentWeek: [Date] = []
    @Published var currentDay = Date()

    @Published var filteredTasks: [TaskModel]?
    @Published var editTask: TaskModel?

    @Published var isEditing: Bool = false
    @Published var showGreetings: Bool = true

    // MARK: - Internal Properties

    var editText: String {
        isEditing ? strings.done : strings.edit
    }

    // MARK: - Private Properties

    private var calendar = Calendar.current
    private var strings = Localizable.Home.self

    // MARK: - Inits

    init() {
        fetchCurrentWeek()
    }

    // MARK: - Internal Functions 

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

    func isSameAsSelectedDay(date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: currentDay)
    }
}
