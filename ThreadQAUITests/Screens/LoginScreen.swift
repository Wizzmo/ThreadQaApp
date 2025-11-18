//
//  LoginScreen.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 18.11.2025.
//

import Foundation

public class LoginScreen {
    lazy var emailField = app.textFields["emailField"]
    lazy var passField = app.textFields["passField"]
    lazy var loginBtn = app.buttons["loginBtn"]
}
