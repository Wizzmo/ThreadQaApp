//
//  ThreadQAUITests.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 11.11.2025.
//

import XCTest

final class LoginTests: XCTestCase {
    private var loginScreen = LoginScreen()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        takeScreenshot()
        app.terminate()
    }
    
    func takeScreenshot(name screenshotName: String? = nil) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot, quality: .original)
        attachment.name = screenshotName ?? name + "_" + UUID().uuidString
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testInvalidLoginCredentials() {
        // Given - тестовые данные
        let alertTitle = "Login Failed"
        let alertDescription = "user not found"
        let email = appHelper.randomString(length: 15)
        let password = appHelper.randomString(length: 8)
        
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
    
    func testInvalidRegisterWrongEmail() {
        let user = UserReg(firstName: "Max", lastName: "Makarov", email: "emailNoAt", password: "123456")
        let registerScreen = loginScreen.goToRegister()
        
        registerScreen.fillFields(userModel: user)
        registerScreen.setSubSwitcher(state: true)
        registerScreen.clickOnRegister()
        appHelper.waitAlertWithText(text: "Alert!")
        
        let hasAlertDescription = appHelper.hasAlertDescription(text: "You cannot register!")
        XCTAssertTrue(hasAlertDescription)
    }
    
    func testInvalidRegisterEmptyOneOfFields() {
        let user = UserReg(firstName: "Max", lastName: "Makarov", email: "test@mail.ru", password: "")
        let registerScreen = loginScreen.goToRegister()
        
        registerScreen.fillFields(userModel: user)
        registerScreen.setSubSwitcher(state: false)
        registerScreen.clickOnRegister()
        appHelper.waitAlertWithText(text: "Alert!")
        
        let hasAlertDescription = appHelper.hasAlertDescription(text: "You cannot register!")
        XCTAssertTrue(hasAlertDescription)
    }
}
