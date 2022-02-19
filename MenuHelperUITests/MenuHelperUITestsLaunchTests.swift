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
        try super.setUpWithError()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        let app = XCUIApplication()
        let count = app.windows.count
        for _ in 0 ..< count {
            app.windows.firstMatch.buttons[XCUIIdentifierCloseWindow].click()
        }
    }

    func testSettingWindowScreenShot() throws {
        let app = XCUIApplication()
        app.launch()
        let mainWindow = app.windows.firstMatch
        do {
            let attachment = XCTAttachment(screenshot: mainWindow.screenshot())
            attachment.name = "Main Window"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
        mainWindow.buttons[String(localized: "Open Preferences Panel...")].click()
        let settingWindow = app.windows.firstMatch
        let toolbarItems = settingWindow.toolbars.buttons.allElementsBoundByIndex
        for toolbarItem in toolbarItems {
            toolbarItem.click()
            let attachment = XCTAttachment(screenshot: settingWindow.screenshot())
            attachment.name = toolbarItem.identifier
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }

    func testAcknowledgementsWindowScreenShot() throws {
        let app = XCUIApplication()
        app.launch()
        let url = try XCTUnwrap(URL(string: "menu-helper://acknowledgements"))
        NSWorkspace.shared.open(url)
        let attachment = XCTAttachment(screenshot: app.windows.firstMatch.screenshot())
        attachment.name = "Acknowledgements Window"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testSuppportWindowScreenShot() throws {
        let app = XCUIApplication()
        app.launch()
        let url = try XCTUnwrap(URL(string: "menu-helper://support"))
        NSWorkspace.shared.open(url)
        sleep(1)
        let supportWindow = app.windows.firstMatch
        let attachment = XCTAttachment(screenshot: supportWindow.screenshot())
        attachment.name = "Support Window"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
