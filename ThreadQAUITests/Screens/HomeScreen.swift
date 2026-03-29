//
//  HomeScreen.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 19.11.2025.
//

import Foundation

public class HomeScreen {
    lazy var profileBtn = app.buttons["Profile"]
    lazy var logOutBtn = app.buttons["LogOut"]
    lazy var addUserBtn = app.buttons["Add"]
    
    lazy var users = app.staticTexts
    
    func getImagesCount() -> Int {
        waitElement(element: profileBtn)
        return app.images.count
    }
    
    func openProfile() -> ProfileScreen {
        waitElement(element: profileBtn).tap()
        return ProfileScreen()
    }
    
    func logOut() -> LoginScreen {
        waitElement(element: logOutBtn).tap()
        return LoginScreen()
    }
    
    func addNewUser() -> NewUserScreen {
        waitElement(element: addUserBtn).tap()
        return NewUserScreen()
    }
    
    func openUser(textOrEmail: String) -> UserDetailScreen {
        let user = users[textOrEmail]
        waitElement(element: user).tap()
        return UserDetailScreen()
    }
}
