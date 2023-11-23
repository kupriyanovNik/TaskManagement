//
//  HabitAddingViewModelTests.swift
//


import XCTest
@testable import TaskManagement

final class HabitAddingViewModelTests: XCTestCase {

    // MARK: - Private Properties

    private var viewModel: HabitAddingViewModel!

    // MARK: - Internal Functions

    override func setUp() {
        super.setUp()
        viewModel = HabitAddingViewModel()
    }

    func testIsAbleToSave() {
        viewModel.shouldNotificate = true 
        XCTAssert(!viewModel.isAbleToSave())
        viewModel.reminderText = "    a"
        XCTAssert(!viewModel.isAbleToSave())
        viewModel.habitTitle = " a"
        XCTAssert(!viewModel.isAbleToSave())
        viewModel.weekDaysIndicies = [0, 1, 4]
        XCTAssert(viewModel.isAbleToSave())
    }
}
