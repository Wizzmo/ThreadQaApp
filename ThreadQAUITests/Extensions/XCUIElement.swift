//
//  XCUIElement.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 20.11.2025.
//

import Foundation
import XCTest

extension XCUIElement {
    func tapAndType(text: String) {
        self.tap()
        self.typeText(text)
        closeKeyboardIfExist()
    }
}

func closeKeyboardIfExist() {
    if app.keyboards.element(boundBy: 0).exists {
        app.typeText("\n")
    }
}

