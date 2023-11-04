//
//  HabitAddingViewModel.swift
//

import Foundation

class HabitAddingViewModel: ObservableObject {

    @Published var showTimePicker: Bool = false

    @Published var habitTitle: String = ""
    @Published var habitDescription: String = ""
    @Published var habitColor: String = "Card-1"
    @Published var weekDays: [String] = []
    @Published var shouldNotificate: Bool = false
    @Published var remainderText: String = ""
    @Published var remainderDate: Date = .now

    @Published var currentWeek: [Date] = []

    private var calendar = Calendar.current

    func fetchCurrentWeek() {
        currentWeek = []
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

    func isAbleToSave() -> Bool {
        let remainderStatus = shouldNotificate ? remainderText == "" : false

        if habitTitle == "" || weekDays.isEmpty || remainderStatus {
            return false
        }

        return true
    }

    func reset() {
        habitTitle = ""
        habitDescription = ""
        habitColor = "Card-1"
        weekDays = []
        shouldNotificate = false
        remainderText = ""
        remainderDate = .now
    }
}
