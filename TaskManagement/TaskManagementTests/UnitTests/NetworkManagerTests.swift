//
//  NetworkManagerTests.swift
//

import XCTest
@testable import TaskManagement

final class NetworkManagerTests: XCTestCase {
    
    // MARK: - Private Properties

    private var manager: NetworkManager!

    // MARK: - Internal Functions

    override func setUp() {
        super.setUp()
        Task {
            manager = await NetworkManager()
        }
    }

    func testSampleRequest() async throws {
        let results = try await DataProvider.fetchData(Requests.GetNews())
        XCTAssertNotEqual(results.count, 0)
    }
}
