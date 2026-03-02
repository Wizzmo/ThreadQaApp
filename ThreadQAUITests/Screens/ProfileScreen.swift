//
//  ProfileScreen.swift
//  ThreadQA
//
//  Created by Maxim Makarov on 18.02.2026.
//

import XCTest

class ProfileScreen {
    lazy var nameText = app.staticTexts["name"]
    lazy var lastNameText = app.staticTexts["lastname"]
    lazy var emailText = app.staticTexts["email"]
    lazy var profileImage = app.images["profileImage"]
    lazy var cancelBtn = app.buttons["Cancel"]
    
    func getName() -> String {
        return nameText.label
    }
    
    func getLastName() -> String {
        return lastNameText.label
    }
    
    func getEmail() -> String {
        return emailText.label
    }
    
    func isImageExist() -> Bool {
        return profileImage.exists
    }
    
    func goBack() -> HomeScreen {
        cancelBtn.tap()
        return HomeScreen()
    }
}
