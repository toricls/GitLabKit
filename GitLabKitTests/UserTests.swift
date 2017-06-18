//
//  UserTests.swift
//  GitLabKitTests
//
//  Copyright (c) 2015 orih. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Cocoa
import XCTest
import OHHTTPStubs

class UserTests: GitLabKitTests {
    override func setUp() {
        super.setUp()
        
        OHHTTPStubs.stubRequests(passingTest: { (request: URLRequest!) -> Bool in
            return request.url?.path.hasPrefix("/api/v3/user") == true
            }, withStubResponse: ( { (request: URLRequest!) -> OHHTTPStubsResponse in
                var filename: String = "test-error.json"
                var statusCode: Int32 = 200
                if let path = request.url?.path {
                    switch path {
                    case let "/api/v3/users":
                        filename = "users.json"
                    case let "/api/v3/users/2":
                        filename = "user-2.json"
                    case let "/api/v3/user":
                        filename = "user.json"
                    default:
                        statusCode = 500
                        break
                    }
                }
                return OHHTTPStubsResponse(fileAtPath: self.resolvePath(filename), statusCode: statusCode, headers: ["Content-Type" : "text/json", "Cache-Control" : "no-cache"])
            }))
    }
    
    /**
    https://gitlab.com/help/api/users.md#for-normal-users
    */
    func testFetchingUsers() {
        let expectation = self.expectation(description: "testFetchingUsers")
        let params = UserQueryParamBuilder()
        client.get(params, handler: { (response: GitLabResponse<User>?, error: NSError?) -> Void in
            XCTAssertEqual(response!.result!.count, 3, "3 records")
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    /**
     https://gitlab.com/help/api/users.md#for-user
     */
    func testFetchingUser() {
        let expectation = self.expectation(description: "testFetchingUser")
        let params = UserQueryParamBuilder().id(2)
        client.get(params, handler: { (response: GitLabResponse<User>?, error: NSError?) -> Void in
            XCTAssertEqual(response!.result!.count, 1, "1 record")
            let user: User = response!.result![0]
            XCTAssertEqual(user.id!.int64Value, 2, "UserId is 2")
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    /**
    https://gitlab.com/help/api/users.md#current-user
    */
    func testFetchingCurrentUser() {
        let expectation = self.expectation(description: "testFetchingCurrentUser")
        let params = UserQueryParamBuilder().mine(true)
        client.get(params, handler: { (response: GitLabResponse<UserFull>?, error: NSError?) -> Void in
            XCTAssertEqual(response!.result!.count, 1, "1 record")
            let user: UserFull = response!.result![0]
            XCTAssertEqual(user.id!.int64Value, 2, "UserId is 2")
            XCTAssertNotNil(user.privateToken, "includes privateToken")
            XCTAssert(user.isKind(of: UserFull.self), "Returns UserFull, not User")
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    // TODO: https://gitlab.com/help/api/users.md#list-ssh-keys
    // TODO: https://gitlab.com/help/api/users.md#list-ssh-keys-for-user
    // TODO: https://gitlab.com/help/api/users.md#single-ssh-key
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
}
