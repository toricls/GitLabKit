//
//  Snippet.swift
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

open class Snippet: GitLabModel, Fetchable {
    open var id: NSNumber?
    open var title: String?
    open var fileName: String?
    open var author: User?
    open var projectId: NSNumber?
    open var expiresAt: Date?
    open var updatedAt: Date?
    open var createdAt: Date?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "id"        : "id",
            "title"     : "title",
            "fileName"  : "file_name",
            "author"    : "author",
            "expiresAt" : "expires_at",
            "updatedAt" : "updated_at",
            "createdAt" : "created_at",
        ]
        return baseKeys + newKeys
    }
    
    class func authorJSONTransformer() -> ValueTransformer {
        return ModelUtil<User>.transformer()
    }
    
    class func expiresAtJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
    class func updatedAtJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
    class func createdAtJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
}

open class SnippetContent: GitLabModel, Fetchable, RawDataFetchable {
    open var content: String?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "content" : "content",
        ]
        return baseKeys + newKeys
    }

}
