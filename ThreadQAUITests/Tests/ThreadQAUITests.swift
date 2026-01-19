//
//  ThreadQAUITests.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 11.11.2025.
//

import XCTest

final class ThreadQAUITests: XCTestCase {
    private var loginScreen = LoginScreen()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
    
    func testInvalidLoginCredentials() {
        // Given - тестовые данные
        let alertTitle = "Try Again"
        let alertDescription = "Invalid credentials"
        let email = "fakeEmail@mail.ru"
        let password = "fakepassw"
        
        // When - Взаимодйствие с тестовыми данными
        loginScreen.auth(email: email, pass: password)
        appHelper.waitAlertWithText(text: alertTitle)
        
        // Then - проверки
        let hasAlertDescription = appHelper.hasAlertDescription(text: alertDescription)
        XCTAssertTrue(hasAlertDescription)
    }
    
    func testValidLoginCredentials() {
        let email = "eve.holt@reqres.in"
        let password = "cityslicka"
        
        let homeScreen = loginScreen.auth(email: email, pass: password)
        let count = homeScreen.getImagesCount()
        
        XCTAssertEqual(count, 6)
    }
    
    func testValidRegister() {
        let user = UserReg(firstName: "Max", lastName: "Makarov", email: "test@mail.ru", password: "12345678")
        let registerScreen = loginScreen.goToRegister()
        
        registerScreen.fillFields(userModel: user)
        registerScreen.setSubSwitcher(state: true)
        registerScreen.clickOnRegister()
        appHelper.waitAlertWithText(text: "Welcome!")
        
        let hasAlertDescription = appHelper.hasAlertDescription(text: "You have successfully registered!")
        XCTAssertTrue(hasAlertDescription)
        
    }
    
    func testUnsuccessAuth() {
        let emailField = app.textFields["emailField"]
        emailField.tap()
        emailField.typeText("123123")
        
        let passField = app.textFields["passField"]
        passField.tap()
        passField.typeText("cityslicka")
        
        let loginBtn = app.buttons["loginBtn"]
        loginBtn.tap()
        
        appHelper.waitAlertWithText(text: "Tap Again")
        
        app.alerts["Tap Again"].waitForExistence(timeout: 8.0)
        let isInvalidAlertExist = appHelper.hasAlertDescription(text: "Invalid credentials")
        XCTAssertTrue(isInvalidAlertExist)
    }
}
