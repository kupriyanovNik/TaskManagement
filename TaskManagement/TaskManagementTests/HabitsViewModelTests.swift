//
//  HabitsViewModelTests.swift
//

import XCTest
@testable import TaskManagement

final class HabitsViewModelTests: XCTestCase {

    // MARK: - Private Properties

    private var viewModel: HabitsViewModel!
    private var strings = Localizable.Home.self

    // MARK: - Internal Functions

    override func setUp() {
        super.setUp()
        viewModel = HabitsViewModel()
    }

    func testEditText() {
        XCTAssertEqual(viewModel.editText, strings.edit)
        viewModel.isEditing = true
        XCTAssertEqual(viewModel.editText, strings.done)
    }
}


