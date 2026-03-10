//
//  NewUserScreen.swift
//  ThreadQA
//
//  Created by Maxim Makarov on 05.03.2026.
//

import XCTest

class NewUserScreen {
    lazy var saveBtn = app.buttons["Save"]
    lazy var cancelBtn = app.buttons["Cancel"]
    lazy var firstNameField = app.textFields["firstName"]
    lazy var lastNameField = app.textFields["lastName"]
    lazy var emailField = app.textFields["email"]
    
    func fillFields(user: UserReg) -> HomeScreen {
        firstNameField.tapAndType(text: user.firstName)
        lastNameField.tapAndType(text: user.lastName)
        emailField.tapAndType(text: user.email)
        saveBtn.tap()
        
        return HomeScreen()
    }
}
