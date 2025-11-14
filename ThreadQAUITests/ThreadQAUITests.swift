//
//  ThreadQAUITests.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 11.11.2025.
//

import XCTest

final class ThreadQAUITests: XCTestCase {
    func testSumTwoNumbers() {
        let app = XCUIApplication()
        app.launch()
        var a = 5
        var b = 10
        var result = a + b
        XCTAssertEqual(15, result)
    }
    
    func testSuccessAuth() {
        let app = XCUIApplication()
        app.launch()
        
        let emailField = app.textFields["emailField"]
        emailField.tap()
        emailField.typeText("eve.holt@reqres.in")
        
        let passField = app.textFields["passField"]
        passField.tap()
        passField.typeText("cityslicka")
        
        let loginBtn = app.buttons["loginBtn"]
        loginBtn.tap()
        
        app.buttons["Profile"].waitForExistence(timeout: 8.0)
        
        let imagesCount = app.images.count
        
        XCTAssertEqual(6, imagesCount)
    }
}
