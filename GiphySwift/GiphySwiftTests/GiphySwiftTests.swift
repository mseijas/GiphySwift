//
//  GiphySwiftTests.swift
//  GiphySwiftTests
//
//  Created by Matias Seijas on 9/12/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import XCTest
@testable import GiphySwift

class GiphySwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testSomething() {
//        Giphy.request(.search(phrase: "britney"))
        Giphy.request(.search(phrase: "britney")) { (data, response, error) in
            print("data: \(data)")
            print("response: \(response)")
            print("error: \(error)")

            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) {

                print(json)
                
            }
        }
    }
    
}
