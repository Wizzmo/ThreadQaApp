//
//  ThreadQAUITests.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 11.11.2025.
//

import XCTest

final class ThreadQAUITests: XCTestCase {
    func testSumTwoNumbers() {
        var a = 5
        var b = 10
        var result = a + b
        XCTAssertEqual(15, result)
    }
}
