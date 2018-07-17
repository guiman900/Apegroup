//
//  ApegroupTests.swift
//  ApegroupTests
//
//  Created by Guillaume Manzano on 16/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import XCTest
@testable import Apegroup

class ApegroupTests: XCTestCase, ApegroupNetworkProtocol {
    
    var expression: XCTestExpectation?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        expression = expectation(description: "network test finished")

        ApegroupNetwork.network.delegate = self
        ApegroupNetwork.network.getRestaurants()

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    internal func restaurantsReceived(restaurants: [Restaurant])
    {
        print("[Restaurant Received] : \(restaurants)");
        print("")
        
        if let restaurantId = restaurants.first?.id
        {
            ApegroupNetwork.network.getMenu(restaurantId: String(restaurantId))
        }
    }
    
    internal func categoriesAndMenuReceived(categories: [Apegroup.Category])
    {
        print("[Menus Received] : \(categories)");
        print("")
        
        expression?.fulfill()
        
        print("NETWORK WORKING : \(categories)");
    }
    
    internal func networkError(error: String)
    {
        print(error)
    }
}
