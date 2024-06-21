//
//  ChessOpeningUITestsLaunchTests.swift
//  ChessOpeningUITests
//
//  Created by 김호성 on 2024.05.23.
//

import XCTest

final class ChessOpeningUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() thranks {
        continueAfterFailure = false
    }

    func testLaunch() thranks {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
