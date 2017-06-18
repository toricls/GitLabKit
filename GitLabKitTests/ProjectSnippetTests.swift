//
//  ProjectSnippetTests.swift
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

class ProjectSnippetTests: GitLabKitTests {
    override func setUp() {
        super.setUp()
        
        OHHTTPStubs.stubRequests(passingTest: { (request: URLRequest!) -> Bool in
            return request.url?.path.hasPrefix("/api/v3/projects/") == true
            }, withStubResponse: ( { (request: URLRequest!) -> OHHTTPStubsResponse in
                var filename: String = "test-error.json"
                var statusCode: Int32 = 200
                if let path = request.url?.path {
                    switch path {
                    case let "/api/v3/projects/1/snippets":
                        filename = "project-snippets.json"
                    case let "/api/v3/projects/1/snippets/1":
                        filename = "project-snippet.json"
                    case let "/api/v3/projects/1/snippets/1/raw":
                        filename = "project-snippet-raw.json"
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
    https://gitlab.com/help/api/project_snippets.md#list-snippets
    */
    func testFetchingProjectSnippets() {
        let expectation = self.expectation(description: "testFetchingProjectSnippets")
        let params = ProjectSnippetQueryParamBuilder(projectId: 1)
        client.get(params, handler: { (response: GitLabResponse<Snippet>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    /**
    https://gitlab.com/help/api/project_snippets.md#single-snippet
    */
    func testFetchingProjectSnippet() {
        let expectation = self.expectation(description: "testFetchingProjectSnippet")
        let params = ProjectSnippetQueryParamBuilder(projectId: 1).snippetId(1)
        client.get(params, handler: { (response: GitLabResponse<Snippet>?, error: NSError?) -> Void in
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    /**
    https://gitlab.com/help/api/project_snippets.md#snippet-content
    */
    func testFetchingProjectSnippetContent() {
        let expectation = self.expectation(description: "testFetchingProjectSnippetContent")
        let params = ProjectSnippetQueryParamBuilder(projectId: 1).snippetId(1)
        client.get(params, handler: { (response: GitLabResponse<SnippetContent>?, error: NSError?) -> Void in
            if let snippet = response?.result![0] {
                print(snippet.content)
            }
            expectation.fulfill()
        })
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    // TODO: https://gitlab.com/help/api/projects.md#protect-single-branch
    // TODO: https://gitlab.com/help/api/projects.md#unprotect-single-branch

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
}
