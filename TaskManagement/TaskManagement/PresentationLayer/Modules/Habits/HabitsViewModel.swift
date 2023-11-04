//
//  HabitsViewModel.swift
//

import Foundation

class HabitsViewModel: ObservableObject {
    @Published var showGreetings: Bool = true

    @Published var isEditing: Bool = false 
}
