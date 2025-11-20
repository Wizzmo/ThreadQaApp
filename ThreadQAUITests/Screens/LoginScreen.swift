//
//  LoginScreen.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 18.11.2025.
//

import Foundation
import XCTest

public class LoginScreen {
    lazy var emailField = app.textFields["emailField"]
    lazy var passField = app.textFields["passField"]
    lazy var loginBtn = app.buttons["loginBtn"]
    lazy var registerBtn = app.buttons["newUserBtn"]
    
    func auth(email: String, pass: String) -> HomeScreen {
        emailField.tapAndType(text: email)
        passField.tapAndType(text: pass)

        loginBtn.tap()
        
        return HomeScreen()
    }
}
