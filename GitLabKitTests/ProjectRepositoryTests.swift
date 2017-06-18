//
//  ProjectRepositoryTests.swift
//  GitLabKitTests
//
//  Copyright (c) 2017 toricls. All rights reserved.
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

class ProjectRepositoryTests: GitLabKitTests {
    override func setUp() {
        super.setUp()
        
        OHHTTPStubs.stubRequests(passingTest: { (request: URLRequest!) -> Bool in
            return request.url?.path.hasPrefix("/api/v3/projects/") == true
            }, withStubResponse: ( { (request: URLRequest!) -> OHHTTPStubsResponse in
                var filename: String = "test-error.json"
                var statusCode: Int32 = 200
                if let path = request.url?.path {
                    switch path {
                    case let "/api/v3/projects/1/repository/tags":
                        filename = "project-repository-tags.json"
                    case let "/api/v3/projects/1/repository/tree":
                        filename = "project-repository-tree.json"
                    default:
                        Logger.log("Unknown path: \(path)" as AnyObject)
                        statusCode = 500
                        break
                    }
                }
                return OHHTTPStubsResponse(fileAtPath: self.resolvePath(filename), statusCode: statusCode, headers: ["Content-Type" : "text/json", "Cache-Control" : "no-cache"])
            }))
    }
    
    /**
    https://gitlab.com/help/api/repositories.md#list-project-repository-tags
    */
    func testFetchingProjectRepositoryTags() {
        let expectation = self.expectation(description: "testFetchingProjectRepositoryTags")
        let params = ProjectTagQueryParamBuilder(projectId: 1)
        client.get(params, handler: { (response: GitLabResponse<Tag>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    // TODO: https://gitlab.com/help/api/repositories.md#create-a-new-tag
    
    /**
    https://gitlab.com/help/api/repositories.md#list-repository-tree
    */
    func testFetchingProjectRepositoryTree() {
        let expectation = self.expectation(description: "testFetchingProjectRepositoryTree")
        let params = ProjectTreeQueryParamBuilder(projectId: 1)
        client.get(params, handler: { (response: GitLabResponse<Tree>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    // TODO: https://gitlab.com/help/api/repositories.md#raw-file-content
    // TODO: https://gitlab.com/help/api/repositories.md#raw-blob-content
    // TODO: https://gitlab.com/help/api/repositories.md#get-file-archive
    // TODO: https://gitlab.com/help/api/repositories.md#compare-branches-tags-or-commits
    // TODO: https://gitlab.com/help/api/repositories.md#contributors

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
}
