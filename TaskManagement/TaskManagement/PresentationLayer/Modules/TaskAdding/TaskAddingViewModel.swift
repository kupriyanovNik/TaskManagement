//
//  TaskAddingViewModel.swift
//

import Foundation

class TaskAddingViewModel: ObservableObject {
    
    // MARK: - Property Wrappers

    @Published var taskTitle: String = ""
    @Published var taskDescription: String = ""
    @Published var taskDate: Date = .now
    @Published var taskCategory: TaskCategory = .normal
    @Published var shouldSendNotification: Bool = false

    // MARK: - Internal Functions

    func reset() {
        self.taskTitle = ""
        self.taskDescription = ""
        self.taskDate = .now
        self.shouldSendNotification = false
        self.taskCategory = .normal
    }
}
