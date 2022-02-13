//
//  MenuHelperUITestsLaunchTests.swift
//  MenuHelperUITests
//
//  Created by Kyle on 2022/2/13.
//

import XCTest

class MenuHelperUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testScreenShot() throws {
        let app = XCUIApplication()
        app.launch()
        let mainWindow = app.windows.firstMatch
        do {
            let attachment = XCTAttachment(screenshot: mainWindow.screenshot())
            attachment.name = "Launch Screen"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
//        print(mainWindow.buttons.count)
//        mainWindow.buttons["打开偏好设置..."].click()
    }
}
