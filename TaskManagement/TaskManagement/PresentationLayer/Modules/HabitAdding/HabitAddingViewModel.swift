//
//  HabitAddingViewModel.swift
//

import Foundation

class HabitAddingViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showTimePicker: Bool = false

    @Published var habitTitle: String = ""
    @Published var habitDescription: String = ""
    @Published var habitColor: String = "Card-1"
    @Published var weekDaysIndicies: [Int] = []
    @Published var shouldNotificate: Bool = false
    @Published var reminderText: String = ""
    @Published var reminderDate: Date = .now

    // MARK: - Internal Functions

    func isAbleToSave() -> Bool {
        return !(
            habitTitle.removeLeadingSpacing() == "" || 
            weekDaysIndicies.isEmpty ||
            (shouldNotificate ? reminderText.removeLeadingSpacing() == "" : false)
        )
    }

    func reset() {
        habitTitle = ""
        habitDescription = ""
        habitColor = "Card-1"
        weekDaysIndicies = []
        shouldNotificate = false
        reminderText = ""
        reminderDate = .now
    }
}
