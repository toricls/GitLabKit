//
//  GitLabKitTests.swift
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

class GitLabKitTests: XCTestCase {
    
    var client: GitLabApiClient!
    
    override func setUp() {
        super.setUp()
        client = GitLabApiClient(host: "https://git.example.com", privateToken: "YOUR-PRIVATE-TOKEN")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
// MARK: - Users tests
    
    func testGetUsersReturnsMultipleResult() {
        let expectation = self.expectationWithDescription("testGetUsersReturnsMultipleResult")
        client.getUsers({ (users: [GitLabUserBasic]?, error: NSError?) -> Void in
            XCTAssertNil(error, "Error must be null.")
            XCTAssertNotNil(users?, "Users must not be null.")
            XCTAssertGreaterThan(UInt(users!.count), UInt(0), "Users must includes multiple user model instances.")
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    func testGetUserReturnsSingleResult() {
        let expectation = self.expectationWithDescription("testGetUserReturnsSingleResult")
        let id: NSNumber = NSNumber(int: 1)
        client.getUser(id.unsignedLongValue, callback: { (users: [GitLabUserBasic]?, error: NSError?) -> Void in
            XCTAssertNil(error, "Error must be null.")
            XCTAssertNotNil(users?, "Users must not be null.")
            XCTAssertEqual(UInt(users!.count), UInt(1), "They returns single user instance.")
            XCTAssertEqual(users![0].id!.unsignedLongValue, id.unsignedLongValue, "Fetched user id of the instance is '1'.")
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    func testGetUserReturnsEmptyArrayIfUserDoesntExist() {
        let expectation = self.expectationWithDescription("testGetUserReturnsEmptyArrayIfUserDoesntExist")
        let id: NSNumber = NSNumber(int: 10000000) // Assuming not found user's id.
        client.getUser(id.unsignedLongValue, callback: { (users: [GitLabUserBasic]?, error: NSError?) -> Void in
            XCTAssertNil(error, "Error must be null when the status code equals to 404 Not Found.")
            XCTAssertNotNil(users?, "Users must not be null.")
            XCTAssertEqual(UInt(users!.count), UInt(0), "User with id: \(id) does not exists.")
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    func testGetCurrentUserReturnsNotNilAndFullUserObject() {
        let expectation = self.expectationWithDescription("testGetCurrentUserReturnsNotNilAndFullUserObject")
        client.getCurrentUser({ (users: [GitLabUserFull]?, error: NSError?) -> Void in
            XCTAssertNil(error, "Error must be null.")
            XCTAssertNotNil(users?, "Users must not be null.")
            XCTAssertEqual(UInt(users!.count), UInt(1), "They returns single user instance.")
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }

// MARK: - Projects tests
    
    func testGetProjectsReturnsMultipleResult() {
        let expectation = self.expectationWithDescription("testGetProjectsReturnsMultipleResult")
        client.getProjects({ (projects: [GitLabProject]?, error: NSError?) -> Void in
            XCTAssertNil(error, "Error must be null.")
            XCTAssertNotNil(projects?, "Projects must not be null.")
            XCTAssertGreaterThan(UInt(projects!.count), UInt(0), "Projects must includes multiple user model instances.")
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    func testGetProjectReturnsSingleResult() {
        
        // fetch a project id first.
        var id: NSNumber?
        let expectation = self.expectationWithDescription("testGetProjectsReturnsMultipleResult2")
        client.getProjects({ (projects: [GitLabProject]?, error: NSError?) -> Void in
            XCTAssertNil(error, "Error must be null.")
            XCTAssertNotNil(projects?, "Projects must not be null.")
            XCTAssertGreaterThan(UInt(projects!.count), UInt(0), "Projects must includes multiple user model instances.")
            // set id for next test...
            id = projects![0].id!
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
        
        let expectation2 = self.expectationWithDescription("testGetProjectsReturnsMultipleResult2")
        client.getProject(id!.unsignedLongValue, callback: { (projects: [GitLabProject]?, error: NSError?) -> Void in
            XCTAssertNil(error, "Error must be null.")
            XCTAssertNotNil(projects?, "Projects must not be null.")
            XCTAssertEqual(UInt(projects!.count), UInt(1), "They returns single project instance.")
            XCTAssertEqual(projects![0].id!.unsignedLongValue, id!.unsignedLongValue, "Fetched project id of the instance is '1'.")
            expectation2.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }

// MARK: - Issues tests
    
    func testGetIssuesReturnsMultipleResult() {
        let expectation = self.expectationWithDescription("testGetIssuesReturnsMultipleResult")
        client.getIssues({ (issues: [GitLabIssue]?, error: NSError?) -> Void in
            XCTAssertNil(error, "Error must be null.")
            XCTAssertNotNil(issues?, "Issues must not be null.")
            XCTAssertGreaterThan(UInt(issues!.count), UInt(0), "Issues must includes multiple issue model instances.")
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    /*func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }*/
    
}
