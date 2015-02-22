//
//  ProjectMemberTests.swift
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

class ProjectMemberTests: GitLabKitTests {
    override func setUp() {
        super.setUp()
        
        OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest!) -> Bool in
            return request.URL.path?.hasPrefix("/api/v3/projects/") == true
            }, withStubResponse: ( { (request: NSURLRequest!) -> OHHTTPStubsResponse in
                var filename: String = "test-error.json"
                var statusCode: Int32 = 200
                if let path = request.URL.path {
                    switch path {
                    case let "/api/v3/projects/31/members":
                        filename = "project-members.json"
                    case let "/api/v3/projects/31/members/16":
                        filename = "project-member.json"
                    default:
                        Logger.log("Unknown path: \(path)")
                        statusCode = 500
                        break
                    }
                }
                return OHHTTPStubsResponse(fileAtPath: self.resolvePath(filename), statusCode: statusCode, headers: ["Content-Type" : "text/json", "Cache-Control" : "no-cache"])
            }))
    }
    
    /**
    https://gitlab.com/help/api/projects.md#list-project-team-members
     */
    func testFetchingProjectMembers() {
        let expectation = self.expectationWithDescription("testFetchingProjectMembers")
        let params = ProjectMemberQueryParamBuilder(projectId: 31)
        client.get(params, { (response: GitLabResponse<Member>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }

    /**
    https://gitlab.com/help/api/projects.md#get-project-team-member
     */
    func testFetchingProjectMember() {
        let expectation = self.expectationWithDescription("testFetchingProjectMember")
        let params = ProjectMemberQueryParamBuilder(projectId: 31).userId(16)
        client.get(params, { (response: GitLabResponse<Member>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    // TODO: https://gitlab.com/help/api/projects.md#add-project-team-member
    // TODO: https://gitlab.com/help/api/projects.md#edit-project-team-member
    // TODO: https://gitlab.com/help/api/projects.md#remove-project-team-member

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
}
