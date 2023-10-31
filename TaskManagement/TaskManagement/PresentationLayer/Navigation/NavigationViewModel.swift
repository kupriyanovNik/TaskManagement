//
//  NavigationViewModel.swift
//

import Foundation

class NavigationViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showTaskAddingView: Bool = false
    @Published var showHabitAddingView: Bool = false

    @Published var selectedTab: Tab = .home
    @Published var showAllTasksView: Bool = false 
}
