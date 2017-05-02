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

open class Branch: GitLabModel, Fetchable {
    open var name: String?
    open var commit: BranchCommit?
    open var _protected: NSNumber?
    open var protected: Bool {
        get { return _protected != nil ? _protected!.boolValue : false }
        set { _protected = NSNumber(value: newValue as Bool)}
    }
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "name"       : "name",
            "commit"     : "commit",
            "_protected" : "protected",
        ]
        return baseKeys + newKeys
    }
    
    class func commitJSONTransformer() -> ValueTransformer {
        return ModelUtil<BranchCommit>.transformer()
    }
}

open class BranchCommit: GitLabModel {
    open var id: String?
    open var parents: [CommitParent]?
    open var tree: String?
    open var message: String?
    open var author: CommitAuthor?
    open var committer: CommitAuthor?
    open var authoredDate: Date?
    open var committedDate: Date?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
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
    
    class func parentsJSONTransformer() -> ValueTransformer {
        return ModelUtil<CommitParent>.arrayTransformer()
    }
    class func authorJSONTransformer() -> ValueTransformer {
        return ModelUtil<CommitAuthor>.transformer()
    }
    class func committerJSONTransformer() -> ValueTransformer {
        return ModelUtil<CommitAuthor>.transformer()
    }
    class func authoredDateJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
    class func committedDateJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
}

open class CommitParent: GitLabModel {
    open var id: String?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "id" : "id",
        ]
        return baseKeys + newKeys
    }
}

open class CommitAuthor: GitLabModel {
    open var name: String?
    open var email: String?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "name"  : "name",
            "email" : "email",
        ]
        return baseKeys + newKeys
    }
}
