//
//  ThreadQAUITests.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 11.11.2025.
//

import XCTest

final class ThreadQAUITests: XCTestCase {
    private var loginScreen = LoginScreen()
    
    func testSuccessRegister() {
        app.launch()
        let registerScreen = loginScreen.goToRegister()
        
        var user = UserReg(firstName: "Max", lastName: "Makarov", email: "test@mail.ru", password: "12345678")
        
        registerScreen.setSubSwitcher(state: false)
        registerScreen.fillFields(userModel: user)
        registerScreen.clickOnRegister()
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
