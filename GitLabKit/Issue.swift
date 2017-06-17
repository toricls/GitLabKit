//
//  Issue.swift
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

open class Issue: GitLabModel, Fetchable, Creatable, Editable {
    open var id: NSNumber?
    open var issueId: NSNumber?
    open var projectId: NSNumber?
    open var title: String?
    open var descriptionText: String?
    //public var state: IssueState?
    open var state: String? // TODO: Use enum instead of String
    open var createdAt: Date?
    open var updatedAt: Date?
    open var labels: [String]?
    open var milestone: Milestone?
    open var assignee: User?
    open var author: User?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
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
        return baseKeys + newKeys
    }
    
    class func milestoneJSONTransformer() -> ValueTransformer {
        return ModelUtil<Milestone>.transformer()
    }
    class func assigneeJSONTransformer() -> ValueTransformer {
        return ModelUtil<User>.transformer()
    }
    class func authorJSONTransformer() -> ValueTransformer {
        return ModelUtil<User>.transformer()
    }
    class func createdAtJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
    class func updatedAtJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
}

public enum IssueState: String {
    case Opend  = "opened"
    case Closed = "closed"
}
