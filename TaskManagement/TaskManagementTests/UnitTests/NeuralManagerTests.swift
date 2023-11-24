//
//  NeuralManagerTests.swift
//

import XCTest
@testable import TaskManagement

final class NeuralManagerTests: XCTestCase {

    // MARK: - Private Properties

    private var manager: NeuralManager!

    // MARK: - Internal Functions

    override func setUp() {
        super.setUp()
        manager = NeuralManager()
    }

    func testSampleCalculation() {
        let first = manager.calculateBedtime(
            hour: 0,
            minute: 0,
            sleepAmount: 0,
            coffeeAmount: 0,
            userAge: 0
        )
        XCTAssertNotNil(first)

        let second = manager.calculateBedtime(
            hour: 7,
            minute: 0,
            sleepAmount: 9,
            coffeeAmount: 1,
            userAge: 7
        )
        XCTAssertNotNil(second)
    }

    func testPerformanceCalculation() {
        measure {
            manager.calculateBedtime(
                hour: 7,
                minute: 0,
                sleepAmount: 8,
                coffeeAmount: 2,
                userAge: 15
            )
        }
    }
}
