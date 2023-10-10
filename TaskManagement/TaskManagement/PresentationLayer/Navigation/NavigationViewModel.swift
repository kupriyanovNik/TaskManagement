//
//  NavigationViewModel.swift
//

import Foundation

class NavigationViewModel: ObservableObject {
    @Published var showAddingView: Bool = false
    @Published var selectedTab: Tab = .home
}
