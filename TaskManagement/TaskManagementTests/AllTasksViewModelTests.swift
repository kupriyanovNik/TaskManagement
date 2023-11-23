//
//  AllTasksViewModelTests.swift
//

import XCTest
@testable import TaskManagement

final class AllTasksViewModelTests: XCTestCase {

    // MARK: - Private Properties

    private var viewModel: AllTasksViewModel!
    private var strings = Localizable.AllTasks.self

    // MARK: - Internal Functions

    override func setUp() {
        super.setUp()
        viewModel = AllTasksViewModel()
    }

    func testEditText() {
        XCTAssertEqual(viewModel.editText, strings.edit)
        viewModel.isEditing = true
        XCTAssertEqual(viewModel.editText, strings.done)
    }
}
