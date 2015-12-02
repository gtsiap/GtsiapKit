// Copyright (c) 2015 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import XCTest
@testable import GtsiapKit

class ApiTest: XCTestCase {
    
    static var offlineStorage = [String : AnyObject]()
    
    private var urlRequest: NSURLRequest {
        let url = NSURL(string: ApiManager.sharedManager.baseUrl + "ip")
        let urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPMethod = "GET"
        return urlRequest
    }
    
    override func setUp() {
        super.setUp()
        ApiManager.sharedManager.baseUrl = "https://httpbin.org/"
    }
    
    func testRequest() {
        let expectation = expectationWithDescription("Request")
        
        let task = ApiManager.sharedManager.task(self.urlRequest) { data in
            expectation.fulfill()
        }.viewControllerForTask(UIViewController())
        
        task.offlineDelegate = self
        
        task.start()
        
        waitForExpectationsWithTimeout(5.0) { XCTAssertNil($0) }
    }
    
    func testNoInternetConnectionWithoutOfflineDelegate() {
        let expectation = expectationWithDescription("RequestNoInternetConnection")
        
        let task = ApiManager.sharedManager.task(self.urlRequest) { data in
            XCTFail("This handler shouldn't be called")
        }.viewControllerForTask(UIViewController())
        
        task.debug = RequestableDebug(.NoInternetConnection) {
            expectation.fulfill()
        }
        
        task.start()
        
        waitForExpectationsWithTimeout(5.0) { error in
            XCTAssertNil(error)
        }
    }
    
    func testNoInternetConnectionWithOfflineDelegate() {
        
        testRequest()
        
        let expectation = expectationWithDescription("RequestNoInternetConnection")
        
        var success = false
        
        let task = ApiManager.sharedManager.task(self.urlRequest) { data in
           let keys = Array(data.keys)
            XCTAssertEqual(keys[0], "origin")
            
            expectation.fulfill()
        }.viewControllerForTask(UIViewController())
        
        task.debug = RequestableDebug(.NoInternetConnection) {
            success = true
        }
        
        task.offlineDelegate = self
        task.start()
        
        waitForExpectationsWithTimeout(5.0) { error in
            XCTAssertNil(error)
            XCTAssert(success)
        }
    }
    
    func testNetworkError() {
        let expectation = expectationWithDescription("RequestNetworkError")
        
        let task = ApiManager.sharedManager.task(self.urlRequest) { data in
            XCTFail("This handler shouldn't be called")
        }.viewControllerForTask(UIViewController())
        
        task.debug = RequestableDebug(.NetworkError) {
            expectation.fulfill()
        }
        
        task.start()
        
        waitForExpectationsWithTimeout(5.0) {
            XCTAssertNil($0)
        
        }
    }
    
    func testNoStart() {
        ApiManager.sharedManager.task(self.urlRequest) { data in
            XCTFail("This handler shouldn't be called")
        }.viewControllerForTask(UIViewController())
        sleep(3)
    }

}

extension ApiTest: RequestableOfflineDelegate {
    func storeRequest(urlRequest: NSURLRequest, data: [String : AnyObject]) {
        ApiTest.offlineStorage = data
    }
    
    func retrieveRequest(urlRequest: NSURLRequest) -> [String : AnyObject]? {
        return ApiTest.offlineStorage
    }
}
