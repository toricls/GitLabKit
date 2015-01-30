//
//  MergeRequest.swift
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

public class MergeRequest: GitLabModel, Fetchable {
    public var id: NSNumber?
    public var mergeRequestId: NSNumber?
    public var targetBranch: NSNumber?
    public var sourceBranch: NSNumber?
    public var title: String?
    //public var state: MergeRequestState?
    public var state: String? // TODO: Use enum instead of String
    public var upvotes: NSNumber?
    public var downvotes: NSNumber?
    public var author: User?
    public var assignee: User?
    public var descriptionText: String?
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
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
    
    class func authorJSONTransformer() -> NSValueTransformer {
        return ModelUtil<User>.transformer()
    }
    class func assigneeJSONTransformer() -> NSValueTransformer {
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