//
//  ThreadQAUITests.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 11.11.2025.
//

import XCTest

final class ThreadQAUITests: XCTestCase {
    private var loginScreen = LoginScreen()
    
    
    func testSumTwoNumbers() {
        let app = XCUIApplication()
        app.launch()
        var a = 5
        var b = 10
        var result = a + b
        XCTAssertEqual(15, result)
    }
    
    func testSuccessAuth() {
        app.launch()
        
        let imagesCount = loginScreen.auth(
            email: "eve.holt@reqres.in",
            pass: "cityslicka"
        ).getImagesCount()

        
        XCTAssertEqual(6, imagesCount)
    }
    
    func testUnsuccessAuth() {
        app.launch()
        
        let emailField = app.textFields["emailField"]
        emailField.tap()
        emailField.typeText("123123")
        
        let passField = app.textFields["passField"]
        passField.tap()
        passField.typeText("cityslicka")
        
        let loginBtn = app.buttons["loginBtn"]
        loginBtn.tap()
        
        app.alerts["Tap Again"].waitForExistence(timeout: 8.0)
        
        let isInvalidAlertExist = app.alerts.staticTexts["Invalid credentials"].exists
        
        XCTAssertTrue(isInvalidAlertExist)
    }
}
