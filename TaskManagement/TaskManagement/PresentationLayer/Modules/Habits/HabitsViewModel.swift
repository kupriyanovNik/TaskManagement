//
//  HabitsViewModel.swift
//

import Foundation

class HabitsViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showGreetings: Bool = true
    @Published var isEditing: Bool = false
    @Published var editHabit: HabitModel?

    // MARK: - Internal Properties

    var editText: String {
        isEditing ? strings.done : strings.edit
    }

    // MARK: - Private Properties

    private var strings = Localizable.Habits.self
}
