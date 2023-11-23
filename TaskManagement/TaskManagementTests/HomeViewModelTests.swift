//
//  HomeViewModelTests.swift
//

import XCTest
@testable import TaskManagement

final class HomeViewModelTests: XCTestCase {

    // MARK: - Private Properties

    private var viewModel: HomeViewModel!
    private var strings = Localizable.Home.self

    // MARK: - Internal Functions

    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel()
    }

    func testCurrentWeekIsNotEmpty() {
        XCTAssertEqual(viewModel.currentWeek.count, 7)
    }

    func testEditText() {
        XCTAssertEqual(viewModel.editText, strings.edit)
        viewModel.isEditing = true
        XCTAssertEqual(viewModel.editText, strings.done)
    }

    func testIsSameAsSelectedDay() {
        XCTAssert(viewModel.isSameAsSelectedDay(date: .now))
    }
}
