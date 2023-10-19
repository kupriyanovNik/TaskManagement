//
//  AddingViewModel.swift
//

import Foundation

class AddingViewModel: ObservableObject {
    @Published var taskTitle: String = ""
    @Published var taskDescription: String = ""
    @Published var taskDate: Date = .now
    @Published var taskCategory: TaskCategory = .normal
    @Published var shouldSendNotification: Bool = false
}
