//
//  Blog_Nerd_RanchUITests.swift
//  Blog Nerd RanchUITests
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import XCTest

class Blog_Nerd_RanchUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatTappingOnAMetadataCellShowsThatPost() {
        let app = XCUIApplication()
        let firstCell = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        let titleText = firstCell.staticTexts.element(matching: .any, identifier: "Post Title").label
        firstCell.tap()
        let postDetailTitle = app.scrollViews.otherElements.staticTexts.element(matching: .any, identifier: "Post Title").label
        
        XCTAssertEqual(titleText, postDetailTitle)
    }
    
    func testThatTappingOnMetadataShowsLoadingScreen() {
        let app = XCUIApplication()
        let firstCell = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        firstCell.tap()
        
        // Test that loading screen shows after tapping postMetadata
        let loadingScreen = app.otherElements["Loading Screen"]
        XCTAssertTrue(loadingScreen.exists)
        
        // After 4 seconds, app should have pushed to PostViewController
        // Confirm that loading screen is gone
        let existsPredicate = NSPredicate(format: "exists == 0")
        expectation(for: existsPredicate, evaluatedWith: loadingScreen, handler: nil)
        waitForExpectations(timeout: 4, handler: nil)
    }
    
}
