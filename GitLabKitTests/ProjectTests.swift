//
//  ProjectTests.swift
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

class ProjectTests: GitLabKitTests {
    override func setUp() {
        super.setUp()
        
        OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest!) -> Bool in
            return request.URL.path?.hasPrefix("/api/v3/project") == true
            }, withStubResponse: ( { (request: NSURLRequest!) -> OHHTTPStubsResponse in
                var filename: String = "test-error.json"
                var statusCode: Int32 = 200
                if let path = request.URL.path {
                    switch path {
                    case let "/api/v3/projects":
                        filename = "projects.json"
                    case let "/api/v3/projects/owned":
                        filename = "projects-owned.json"
                    case let "/api/v3/projects/10":
                        filename = "project-10.json"
                    //case let "/api/v3/projects/single%2Fproject":
                    case let "/api/v3/projects/single/project":
                        filename = "project-10.json"
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
    https://gitlab.com/help/api/projects.md#list-projects
    */
    func testFetchingProjects() {
        let expectation = self.expectationWithDescription("testFetchingProjects")
        let params = ProjectQueryParamBuilder()
        client.get(params, { (response: GitLabResponse<Project>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    /**
     https://gitlab.com/help/api/projects.md#list-owned-projects
     */
    func testFetchingProjectsOwned() {
        let expectation = self.expectationWithDescription("testFetchingProjectsOwned")
        let params = ProjectQueryParamBuilder().owned(true)
        client.get(params, { (response: GitLabResponse<Project>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    /**
    https://gitlab.com/help/api/projects.md#get-single-project
    */
    func testFetchingProjectById() {
        let expectation = self.expectationWithDescription("testFetchingProjectById")
        let params = ProjectQueryParamBuilder().id(10)
        client.get(params, { (response: GitLabResponse<Project>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    /**
    https://gitlab.com/help/api/projects.md#get-single-project
    */
    func testFetchingProjectByName() {
        let expectation = self.expectationWithDescription("testFetchingProjectByName")
        let params = ProjectQueryParamBuilder().nameAndNamespace("project", namespace: "single")
        client.get(params, { (response: GitLabResponse<Project>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }

    // TODO: https://gitlab.com/help/api/projects.md#create-project
    // TODO: https://gitlab.com/help/api/projects.md#create-project-for-user
    // TODO: https://gitlab.com/help/api/projects.md#fork-project
    // TODO: https://gitlab.com/help/api/projects.md#remove-project
    
    // Project branches tests are implemented in ProjectBranchTests.swift
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
}
