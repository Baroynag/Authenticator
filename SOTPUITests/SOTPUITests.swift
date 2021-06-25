//
//  SOTPUITests.swift
//  SOTPUITests
//
//  Created by Anzhela Baroyan on 24.06.2021.
//  Copyright © 2021 Anzhela Baroyan. All rights reserved.
//

import XCTest

class SOTPUITests: XCTestCase {

	let app = XCUIApplication()

	override func setUpWithError() throws {
		continueAfterFailure = false
	}

	override func tearDownWithError() throws {
	}

	func testCreateRecordFromGreetingScreen() throws {
		app.launch()
	}

}
