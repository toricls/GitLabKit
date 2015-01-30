//
//  Branch.swift
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

public class Branch: GitLabModel, Fetchable {
    public var name: String?
    public var commit: BranchCommit?
    public var _protected: NSNumber?
    public var protected: Bool {
        get { return _protected? != nil ? _protected!.boolValue : false }
        set { _protected = NSNumber(bool: newValue)}
    }
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
            "name"       : "name",
            "commit"     : "commit",
            "_protected" : "protected",
        ]
        return baseKeys + newKeys
    }
    
    class func commitJSONTransformer() -> NSValueTransformer {
        return ModelUtil<BranchCommit>.transformer()
    }
}

public class BranchCommit: GitLabModel {
    public var id: String?
    public var parents: [CommitParent]?
    public var tree: String?
    public var message: String?
    public var author: CommitAuthor?
    public var committer: CommitAuthor?
    public var authoredDate: NSDate?
    public var committedDate: NSDate?
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
            "id"            : "id",
            "parents"       : "parents",
            "tree"          : "tree",
            "message"       : "message",
            "author"        : "author",
            "committer"     : "committer",
            "authoredDate"  : "authored_date",
            "committedDate" : "committed_date",
        ]
        return baseKeys + newKeys
    }
    
    class func parentsJSONTransformer() -> NSValueTransformer {
        return ModelUtil<CommitParent>.arrayTransformer()
    }
    class func authorJSONTransformer() -> NSValueTransformer {
        return ModelUtil<CommitAuthor>.transformer()
    }
    class func committerJSONTransformer() -> NSValueTransformer {
        return ModelUtil<CommitAuthor>.transformer()
    }
    class func authoredDateJSONTransformer() -> NSValueTransformer {
        return dateTimeTransformer
    }
    class func committedDateJSONTransformer() -> NSValueTransformer {
        return dateTimeTransformer
    }
}

public class CommitParent: GitLabModel {
    public var id: String?
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
            "id" : "id",
        ]
        return baseKeys + newKeys
    }
}

public class CommitAuthor: GitLabModel {
    public var name: String?
    public var email: String?
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
            "name"  : "name",
            "email" : "email",
        ]
        return baseKeys + newKeys
    }
}