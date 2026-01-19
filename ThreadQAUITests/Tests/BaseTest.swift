//
//  BaseTest.swift
//  ThreadQAUITests
//
//  Created by Maxim Makarov on 18.11.2025.
//

import Foundation
import XCTest

let app = XCUIApplication()
let appHelper = AppHelper()

func waitElement(element: XCUIElement) -> XCUIElement {
    if !element.waitForExistence(timeout: 8.0) {
        XCTFail("Element not found: \(element.description)")
    }
    
    return element
}
