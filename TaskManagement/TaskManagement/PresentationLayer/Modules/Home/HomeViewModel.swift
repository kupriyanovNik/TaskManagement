//
//  HomeViewModel.swift
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showCalendar: Bool = true 
    @Published var showHeaderTap: Bool = false

    @Published var filteredTasks: [TaskModel]?
    @Published var editTask: TaskModel?

    @Published var isEditing: Bool = false
    @Published var showGreetings: Bool = true

    // MARK: - Internal Properties

    var editText: String {
        isEditing ? strings.done : strings.edit
    }

    // MARK: - Private Properties

    private var calendar = Calendar.current
    private var strings = Localizable.Home.self

}
