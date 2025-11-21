//
//  HomeScreen.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 19.11.2025.
//

import Foundation

public class HomeScreen {
    lazy var profileBtn = app.buttons["Profile"]
    
    func getImagesCount() -> Int {
        waitElement(element: profileBtn)
        return app.images.count
    }
}
