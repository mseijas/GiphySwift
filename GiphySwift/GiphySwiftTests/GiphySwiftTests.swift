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
    
    func testSearch() {
        let expectation = XCTestExpectation(description: "Search gifs loaded")
        Giphy.Gif.request(GiphyRequest.Gif.Search.search("britney")) { (result) in
            self.handleResult(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testTrending() {
        let expectation = XCTestExpectation(description: "Trending gifs loaded")
        Giphy.Gif.request(GiphyRequest.Gif.trending, limit: 25) { (result: GiphyRequestResult) in
            self.handleResult(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func handleResult<T>(_ result: GiphyResult<T>) {
        switch(result) {
        case .error(let error):
            XCTFail("Received error: \(error)")
        case .success(result: let result, properties: let properties):
            print("Result: \(result)")
            if let properties = properties {
                print("Properties: \(properties)")
            }
        }
    }
    
}
