//
//  Commit.swift
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

public class Commit: GitLabModel, Fetchable {
    public var id: String?
    public var shortId: String?
    public var title: String?
    public var authorName: String?
    public var authorEmail: String?
    public var message: String?
    public var createdAt: NSDate?
    
    // for single commit only
    public var committedDate: NSDate?
    public var authoredDate: NSDate?
    public var parentIds: [String]?
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
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
    class func createdAtJSONTransformer() -> NSValueTransformer {
        return dateTimeTransformer
    }
    class func committedDateJSONTransformer() -> NSValueTransformer {
        return dateTimeTransformer
    }
    class func authoredDateJSONTransformer() -> NSValueTransformer {
        return dateTimeTransformer
    }
}