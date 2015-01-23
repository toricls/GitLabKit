//
//  GitLabIssue.swift
//  GitLabKit
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

import Foundation
import Mantle

public class GitLabIssue: MTLModel, MTLJSONSerializing {
    public var id: NSNumber?
    public var issueId: NSNumber?
    public var projectId: NSNumber?
    public var title: String?
    public var descriptionText: String?
    public var state: String?
    public var createdAt: NSDate?
    public var updatedAt: NSDate?
    public var labels: [String]?
    public var milestone: GitLabMilestone?
    public var assignee: GitLabUserBasic?
    public var author: GitLabUserBasic?
    
    public class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "id"              : "id",
            "issueId"         : "iid",
            "projectId"       : "project_id",
            "title"           : "title",
            "descriptionText" : "description",
            "state"           : "state",
            "createdAt"       : "created_at",
            "updatedAt"       : "updated_at",
            "labels"          : "labels",
            "milestone"       : "milestone",
            "assignee"        : "assignee",
            "author"          : "author",
        ]
    }
}