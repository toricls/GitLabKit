//
//  Event.swift
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

open class Event: GitLabModel, Fetchable {
    open var id: NSNumber?
    open var projectId: NSNumber?
    open var actionName: String?
    open var targetId: NSNumber?
    open var targetType: String?
    open var authorId: NSNumber?
    open var authorUsername: String?
    open var data: EventData?
    open var targetTitle: String?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "id"             : "id",
            "projectId"      : "project_id",
            "actionName"     : "action_name",
            "targetId"       : "target_id",
            "targetType"     : "target_type",
            "authorId"       : "author_id",
            "authorUsername" : "author_username",
            "data"           : "data",
            "targetTitle"    : "target_title",
        ]
        return baseKeys + newKeys
    }
    
    class func dataJSONTransformer() -> ValueTransformer {
        return ModelUtil<EventData>.transformer()
    }
}

open class EventData: GitLabModel {
    
    open var before: String?
    open var after: String?
    open var ref: String?
    open var userId: NSNumber?
    open var userName: String?
    open var repository: Repository?
    open var commits: [EventCommit]?
    open var totalCommitsCount: NSNumber?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "before"            : "before",
            "after"             : "after",
            "ref"               : "ref",
            "userId"            : "user_id",
            "userName"          : "user_name",
            "repository"        : "repository",
            "commits"           : "commits",
            "totalCommitsCount" : "total_commits_count",
        ]
        return baseKeys + newKeys
    }
    
    class func repositoryJSONTransformer() -> ValueTransformer {
        return ModelUtil<Repository>.transformer()
    }
    class func commitsJSONTransformer() -> ValueTransformer {
        return ModelUtil<EventCommit>.arrayTransformer()
    }
}

open class Repository: GitLabModel {
    
    open var name: String?
    open var url: String?
    open var descriptionText: String?
    open var homepage: String?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "name"            : "name",
            "url"             : "url",
            "descriptionText" : "description",
            "homepage"        : "homepage",
        ]
        return baseKeys + newKeys
    }
}

open class EventCommit: GitLabModel {
    
    open var id: NSNumber?
    open var message: String?
    open var timestamp: Date?
    open var url: String?
    open var author: CommitAuthor?
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
            "id"        : "id",
            "message"   : "message",
            "timestamp" : "timestamp",
            "url"       : "url",
            "author"    : "author",
        ]
        return baseKeys + newKeys
    }
    
    class func timestampJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
    class func authorJSONTransformer() -> ValueTransformer {
        return ModelUtil<CommitAuthor>.transformer()
    }
}
