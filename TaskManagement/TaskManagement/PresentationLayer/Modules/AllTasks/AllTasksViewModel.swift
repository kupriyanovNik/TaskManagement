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

    // MARK: - Internal Properties

    var editText: String {
        isEditing ? strings.done : strings.edit
    }

    // MARK: - Private Properties

    private var strings = Localizable.AllTasks.self
}
