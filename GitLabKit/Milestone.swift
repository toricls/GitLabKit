//
//  Milestone.swift
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

open class Milestone: GitLabModel, Fetchable {
    open var id: NSNumber?
    open var milestoneId: NSNumber?
    open var projectId: NSNumber?
    open var title: String?
    open var descriptionText: String?
    open var state: String?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var dueDate: Date?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "id"              : "id",
            "milestoneId"     : "iid",
            "projectId"       : "project_id",
            "title"           : "title",
            "descriptionText" : "description",
            "state"           : "state",
            "createdAt"       : "created_at",
            "updatedAt"       : "updated_at",
            "dueDate"         : "due_date",
        ]
        return baseKeys + newKeys
    }
    
    class func createdAtJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
    class func updatedAtJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
    class func dueDateJSONTransformer() -> ValueTransformer {
        return dateTransformer
    }
}
