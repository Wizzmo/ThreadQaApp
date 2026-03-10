//
//  UserTests.swift
//  ThreadQA
//
//  Created by Maxim Makarov on 18.02.2026.
//

import XCTest

class UserTests: XCTestCase {
    private var loginScreen = LoginScreen()
    private var homeScreen: HomeScreen!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        
        let email = "eve.holt@reqres.in"
        let password = "cityslicka"
        
        homeScreen = loginScreen.auth(email: email, pass: password)
    }
    
    func testUserInfo() {
        var profileScreen = homeScreen.openProfile()
        
        let emailUser = profileScreen.getEmail()
        let name = profileScreen.getName()
        let lastName = profileScreen.getLastName()
        let hasImage = profileScreen.isImageExist()
        
        XCTAssertEqual(emailUser, "janet.weaver@reqres.in")
        XCTAssertEqual(name, "Janet")
        XCTAssertEqual(lastName, "Weaver")
        XCTAssertTrue(hasImage)
    }
    
    func testLogOut() {
        var isLogOuted = homeScreen.logOut().isLoginScreen()
        XCTAssertTrue(isLogOuted)
    }
    
    func testAddNewUser() {
        let user = UserReg(firstName: "Boris", lastName: "Novikiv", email: "test2@mail.ru", password: "")
        let userCountBefore = homeScreen.getImagesCount()
        
        let userCountAfter = homeScreen
            .addNewUser()
            .fillFields(user: user)
            .getImagesCount()
        XCTAssertNotEqual(userCountBefore, userCountAfter)
        
    }
}
