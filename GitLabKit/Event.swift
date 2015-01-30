//
//  Event.swift
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

public class Event: GitLabModel, Fetchable {
    public var id: NSNumber?
    public var projectId: NSNumber?
    public var actionName: String?
    public var targetId: NSNumber?
    public var targetType: String?
    public var authorId: NSNumber?
    public var authorUsername: String?
    public var data: EventData?
    public var targetTitle: String?
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
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
    
    class func dataJSONTransformer() -> NSValueTransformer {
        return ModelUtil<EventData>.transformer()
    }
}

public class EventData: GitLabModel {
    
    public var before: String?
    public var after: String?
    public var ref: String?
    public var userId: NSNumber?
    public var userName: String?
    public var repository: Repository?
    public var commits: [EventCommit]?
    public var totalCommitsCount: NSNumber?
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
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
    
    class func repositoryJSONTransformer() -> NSValueTransformer {
        return ModelUtil<Repository>.transformer()
    }
    class func commitsJSONTransformer() -> NSValueTransformer {
        return ModelUtil<EventCommit>.arrayTransformer()
    }
}

public class Repository: GitLabModel {
    
    public var name: String?
    public var url: String?
    public var descriptionText: String?
    public var homepage: String?
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
            "name"            : "name",
            "url"             : "url",
            "descriptionText" : "description",
            "homepage"        : "homepage",
        ]
        return baseKeys + newKeys
    }
}

public class EventCommit: GitLabModel {
    
    public var id: NSNumber?
    public var message: String?
    public var timestamp: NSDate?
    public var url: String?
    public var author: CommitAuthor?
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
            "id"        : "id",
            "message"   : "message",
            "timestamp" : "timestamp",
            "url"       : "url",
            "author"    : "author",
        ]
        return baseKeys + newKeys
    }
    
    class func timestampJSONTransformer() -> NSValueTransformer {
        return dateTimeTransformer
    }
    class func authorJSONTransformer() -> NSValueTransformer {
        return ModelUtil<CommitAuthor>.transformer()
    }
}