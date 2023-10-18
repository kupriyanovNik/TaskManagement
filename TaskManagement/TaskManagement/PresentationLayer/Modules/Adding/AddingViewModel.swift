//
//  AddingViewModel.swift
//

import Foundation

class AddingViewModel: ObservableObject {
    @Published var taskTitle: String = ""
    @Published var taskDescription: String = ""
    @Published var taskDate: Date = .now
    @Published var shouldSendNotification: Bool = false 
}
