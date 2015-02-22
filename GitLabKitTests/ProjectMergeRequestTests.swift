//
//  ProjectMergeRequestTests.swift
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

class ProjectMergeRequestTests: GitLabKitTests {
    override func setUp() {
        super.setUp()
        
        OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest!) -> Bool in
            return request.URL.path?.hasPrefix("/api/v3/projects/") == true
            }, withStubResponse: ( { (request: NSURLRequest!) -> OHHTTPStubsResponse in
                var filename: String = "test-error.json"
                var statusCode: Int32 = 200
                if let path = request.URL.path {
                    switch path {
                    case let "/api/v3/projects/1/merge_requests":
                        filename = "project-mrs.json"
                    case let "/api/v3/projects/1/merge_requests?state=closed":
                        filename = "project-mrs-by-status.json"
                    case let "/api/v3/projects/1/merge_requests?state=mereged":
                        filename = "project-mrs-by-status-mereged.json"
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
    https://gitlab.com/help/api/merge_requests.md#list-merge-requests
    */
    func testFetchingProjectMergeRequests() {
        let expectation = self.expectationWithDescription("testFetchingProjectMergeRequests")
        let params = ProjectMergeRequestQueryParamBuilder(projectId: 1)
        client.get(params, { (response: GitLabResponse<MergeRequest>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    /**
    https://gitlab.com/help/api/merge_requests.md#list-merge-requests
    */
    func testFetchingProjectClosedMergeRequests() {
        let expectation = self.expectationWithDescription("testFetchingProjectClosedMergeRequests")
        let params = ProjectMergeRequestQueryParamBuilder(projectId: 1).state(.Closed)
        client.get(params, { (response: GitLabResponse<MergeRequest>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    /**
    https://gitlab.com/help/api/merge_requests.md#list-merge-requests
    */
    func testFetchingProjectMergedMergeRequests() {
        let expectation = self.expectationWithDescription("testFetchingProjectMergedMergeRequests")
        let params = ProjectMergeRequestQueryParamBuilder(projectId: 1).state(.Merged)
        client.get(params, { (response: GitLabResponse<MergeRequest>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(5, nil)
    }
    
    // TODO: https://gitlab.com/help/api/merge_requests.md#get-single-mr
    // TODO: https://gitlab.com/help/api/merge_requests.md#create-mr
    // TODO: https://gitlab.com/help/api/merge_requests.md#update-mr
    // TODO: https://gitlab.com/help/api/merge_requests.md#accept-mr
    // TODO: https://gitlab.com/help/api/merge_requests.md#post-comment-to-mr
    // TODO: https://gitlab.com/help/api/merge_requests.md#get-the-comments-on-a-mr
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
}
