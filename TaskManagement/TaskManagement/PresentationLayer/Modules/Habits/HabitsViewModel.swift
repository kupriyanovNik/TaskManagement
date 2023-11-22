//
//  HabitsViewModel.swift
//

import Foundation

class HabitsViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showGreetings: Bool = true
    @Published var isEditing: Bool = false
    @Published var editHabit: HabitModel?
}
