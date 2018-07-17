//
//  ApegroupUITests.swift
//  ApegroupUITests
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import XCTest

class ApegroupUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        app.launch()
        
        //let articleTableView = app.tables["tableview"]
        let articleTableView = app.tables.element(boundBy: 0)
        XCTAssertTrue(articleTableView.exists, "The article tableview exists")
        
        // Get an array of cells
        let tableCell = articleTableView.cells.element(boundBy: 0)
        XCTAssertTrue(tableCell.exists, "The cell exists")

        tableCell.tap()
        XCTAssertTrue((app.staticTexts["Pizzeria Apan"].exists || app.staticTexts["Pizza Heaven"].exists), "Detail view loaded")
   
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.staticTexts["Restaurants"].exists , "Master view loaded")
    }
    
}
