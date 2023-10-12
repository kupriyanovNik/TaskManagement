//
//  AllTasksViewModel.swift
//

import Foundation

class AllTasksViewModel: ObservableObject {
    @Published var isEditing: Bool = false
    @Published var showGreetings: Bool = true
}
