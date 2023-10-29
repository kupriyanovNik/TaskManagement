//
//  AllTasksViewModel.swift
//

import Foundation

class AllTasksViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var isEditing: Bool = false

    @Published var showHeaderTap: Bool = false 
    @Published var showFilteringView: Bool = false
    @Published var filteringCategory: TaskCategory?

    @Published var verticalOffset: CGFloat = .zero
}
