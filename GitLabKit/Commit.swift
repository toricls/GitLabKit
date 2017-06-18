//
//  Commit.swift
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

open class Commit: GitLabModel, Fetchable {
    open var id: String?
    open var shortId: String?
    open var title: String?
    open var authorName: String?
    open var authorEmail: String?
    open var message: String?
    open var createdAt: Date?
    
    // for single commit only
    open var committedDate: Date?
    open var authoredDate: Date?
    open var parentIds: [String]?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "id"            : "id",
            "shortId"       : "short_id",
            "title"         : "title",
            "authorName"    : "author_name",
            "authorEmail"   : "author_email",
            "message"       : "message",
            "createdAt"     : "created_at",
            
            "committedDate" : "committed_date",
            "authoredDate"  : "authored_date",
            "parentIds"     : "parent_ids",
        ]
        return baseKeys + newKeys
    }
    class func createdAtJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
    class func committedDateJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
    class func authoredDateJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
}
