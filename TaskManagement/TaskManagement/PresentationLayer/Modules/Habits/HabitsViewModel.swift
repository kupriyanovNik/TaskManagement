//
//  HabitsViewModel.swift
//

import Foundation

class HabitsViewModel: ObservableObject {
    @Published var showGreetings: Bool = true 

    @Published var weekDays: [String] = []

    @Published var currentWeek: [Date] = []

    private var calendar = Calendar.current

    init() {
        fetchCurrentWeek()
    }

    func fetchCurrentWeek() {
        weekDays = []
        currentWeek = []

        let today = Date()
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        guard let firstWeekDay = week?.start else { return }

        (0...6).forEach {
            if let weekday = calendar.date(byAdding: .day, value: $0, to: firstWeekDay) {
                let extractedWeekday = extractDate(date: weekday, format: Constants.DateFormats.forDateLiteral)

                self.currentWeek.append(weekday)
                self.weekDays.append(extractedWeekday)
            }
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
