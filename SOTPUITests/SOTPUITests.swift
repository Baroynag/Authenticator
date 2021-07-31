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

	func testCreateRecordFromGretteingScreen() throws {
		app.launchArguments = ["greetingScreenTest"]
		app.launch()
		app.buttons["greetingScreenCreateButton"].tap()
		let accountTextField = app.textFields["Account"]
		accountTextField.tap()
		accountTextField.typeText("Account1")
		let secretKeyTextField = app.textFields["Secret key"]
		secretKeyTextField.tap()
		secretKeyTextField.typeText("Secret1")
		app.keyboards.buttons["Return"].tap()
		app.buttons["addAccountScreenCreateButton"].tap()
		XCTAssert(app.staticTexts["Account1"].exists)
	}

	func testCreateRecordFromTableView() throws {

		app.launch()

		let addButton = app.buttons.element(matching: .button, identifier: "mainScreenAddButton")
		addButton.tap()
		let accountTextField = app.textFields["Account"]
		accountTextField.tap()
		accountTextField.typeText("Account2")
		let secretKeyTextField = app.textFields["Secret key"]
		secretKeyTextField.tap()
		secretKeyTextField.typeText("Secret2")
		app.keyboards.buttons["Return"].tap()
		app.buttons["addAccountScreenCreateButton"].tap()
		XCTAssert(app.staticTexts["Account2"].exists)
	}

	func testSaveToFile() throws {
		app.launch()
		app.buttons["settings"].tap()
		app.tables.cells.element(boundBy: 1).tap()
		let password = app.secureTextFields["Password"]
		password.tap()
		password.typeText("123")
		let confirmPassword = app.secureTextFields["Confirm password"]
		confirmPassword.tap()
		confirmPassword.typeText("123")
		app.buttons["Ok"].tap()
		app.buttons["Save to Files"].tap()
		app.buttons["Save"].tap()
	}

	func testPurchaseScreen() throws {
		app.launch()
		app.buttons["settings"].tap()
		app.buttons["settingsScreenPurchaseButton"].tap()
		app.buttons["oneDollarPurchaseButton"].tap()
		let message = app.staticTexts["Thank you for your support!"]
		XCTAssertTrue(message.waitForExistence(timeout: 5))
	}

}
