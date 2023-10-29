//
//  NavigationViewModel.swift
//

import Foundation

class NavigationViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showAddingView: Bool = false
    @Published var selectedTab: Tab = .home
    @Published var showAllTasksView: Bool = false 
}
