//
//  AppHelper.swift
//  ThreadQA
//
//  Created by Maxim Makarov on 16.12.2025.
//
import XCTest

class AppHelper {
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func randomInt(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    func waitAlertWithText(text: String) {
        let alert = app.alerts[text]
        waitElement(element: alert)
    }
    
    func hasAlertDescription(text: String) -> Bool {
        return app.alerts.staticTexts[text].exists
    }
    
    func hideApp() {
        XCUIDevice.shared.press(XCUIDevice.Button.home)
    }
}
