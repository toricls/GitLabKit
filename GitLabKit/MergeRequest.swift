//
//  MergeRequest.swift
//  GitLabKit
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

import Foundation
import Mantle

open class MergeRequest: GitLabModel, Fetchable {
    open var id: NSNumber?
    open var mergeRequestId: NSNumber?
    open var targetBranch: NSNumber?
    open var sourceBranch: NSNumber?
    open var title: String?
    //public var state: MergeRequestState?
    open var state: String? // TODO: Use enum instead of String
    open var upvotes: NSNumber?
    open var downvotes: NSNumber?
    open var author: User?
    open var assignee: User?
    open var descriptionText: String?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "id"              : "id",
            "mergeRequestId"  : "iid",
            "targetBranch"    : "target_branch",
            "sourceBranch"    : "source_branch",
            "title"           : "title",
            "state"           : "state",
            "upvotes"         : "upvotes",
            "downvotes"       : "downvotes",
            "author"          : "author",
            "assignee"        : "assignee",
            "descriptionText" : "description",
        ]
        return baseKeys + newKeys
    }
    
    class func authorJSONTransformer() -> ValueTransformer {
        return ModelUtil<User>.transformer()
    }
    class func assigneeJSONTransformer() -> ValueTransformer {
        return ModelUtil<User>.transformer()
    }
}

public enum MergeRequestState: String {
    case Opend  = "opened"
    case Closed = "closed"
    case Merged = "merged"
}

public enum MergeRequestOrderBy: String {
    case CreatedAt = "created_at"
    case UpdatedAt = "updated_at"
}

public enum MergeRequestSort: String {
    case Asc = "asc"
    case Desc = "desc"
}
