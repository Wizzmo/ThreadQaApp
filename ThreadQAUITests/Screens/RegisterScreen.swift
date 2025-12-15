//
//  RegisterScreen.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 21.11.2025.
//

import Foundation

public class RegisterScreen {
    lazy var firstNameField = app.textFields["firstNameField"]
    lazy var lastNameField = app.textFields["lastNameField"]
    lazy var emailField = app.textFields["emailField"]
    lazy var passField = app.textFields["passField"]
    lazy var subSwitcher = app.switches["subSwitcher"]
    
    lazy var backBtn = app.buttons["loginBackBtn"]
    lazy var registerBtn = app.buttons["registerBtn"]
    
    func fillFields(firstName: String, lastName: String, email: String, pass: String) {
        firstNameField.tapAndType(text: firstName)
        lastNameField.tapAndType(text: lastName)
        emailField.tapAndType(text: email)
        passField.tapAndType(text: pass)
    }
    
    func fillFields(userModel: UserReg) {
        firstNameField.tapAndType(text: userModel.firstName)
        lastNameField.tapAndType(text: userModel.lastName)
        emailField.tapAndType(text: userModel.email)
        passField.tapAndType(text: userModel.password)
    }
    
    func clickOnRegister() {
        registerBtn.tap()
    }
    
    func setSubSwitcher(state: Bool) {
        let value = subSwitcher.value as? String
        
        if (value == "0" && state) {
            subSwitcher.tap()
            return
        }
        
        if (value == "1" && !state) {
            subSwitcher.tap()
            return
        }
    }
}
