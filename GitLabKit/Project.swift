//
//  Project.swift
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

public class Project: GitLabModel, Fetchable, Creatable, Editable, Deletable {
    
    public var id: NSNumber?
    public var descriptionText: String? // "description" as a property name is not allowed by compiler
    public var defaultBranch: String?
    public var _isPublic: NSNumber?
    public var isPublic: Bool {
        get { return _isPublic? != nil ? _isPublic!.boolValue : false }
        set { _isPublic = NSNumber(bool: newValue)}
    }
    public var visibilityLevel: NSNumber?
    public var sshUrlToRepo: String?
    public var httpUrlToRepo: String?
    public var webUrl: String?
    public var owner: User?
    public var name: String?
    public var nameWithNamespace: String?
    public var path: String?
    public var pathWithNamespace: String?
    public var _issuesEnabled: NSNumber?
    public var issuesEnabled: Bool {
        get { return _issuesEnabled? != nil ? _issuesEnabled!.boolValue : false }
        set { _issuesEnabled = NSNumber(bool: newValue)}
    }
    public var _mergeRequestsEnabled: NSNumber?
    public var mergeRequestsEnabled: Bool {
        get { return _mergeRequestsEnabled? != nil ? _mergeRequestsEnabled!.boolValue : false }
        set { _mergeRequestsEnabled = NSNumber(bool: newValue)}
    }
    public var _wikiEnabled: NSNumber?
    public var wikiEnabled: Bool {
        get { return _wikiEnabled? != nil ? _wikiEnabled!.boolValue : false }
        set { _wikiEnabled = NSNumber(bool: newValue)}
    }
    public var _snippetsEnabled: NSNumber?
    public var snippetsEnabled: Bool {
        get { return _snippetsEnabled? != nil ? _snippetsEnabled!.boolValue : false }
        set { _snippetsEnabled = NSNumber(bool: newValue)}
    }
    public var createdAt: NSDate?
    public var lastActivityAt: NSDate?
    public var namespace: Namespace?
    public var _archived: NSNumber?
    public var archived: Bool {
        get { return _archived? != nil ? _archived!.boolValue : false }
        set { _archived = NSNumber(bool: newValue)}
    }
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
            "id"                    : "id",
            "descriptionText"       : "description",
            "defaultBranch"         : "default_branch",
            "_isPublic"             : "public",
            "visibilityLevel"       : "visibility_level",
            "sshUrlToRepo"          : "ssh_url_to_repo",
            "httpUrlToRepo"         : "http_url_to_repo",
            "webUrl"                : "web_url",
            "owner"                 : "owner",
            "name"                  : "name",
            "nameWithNamespace"     : "name_with_namespace",
            "path"                  : "path",
            "pathWithNamespace"     :"path_with_namespace",
            "_issuesEnabled"        : "issues_enabled",
            "_mergeRequestsEnabled" : "merge_requests_enabled",
            "_wikiEnabled"          : "wiki_enabled",
            "_snippetsEnabled"      : "snippets_enabled",
            "createdAt"             : "created_at",
            "lastActivityAt"        : "last_activity_at",
            "namespace"             : "namespace",
            "_archived"             : "archived"
        ]
        return baseKeys + newKeys
    }
    
    class func ownerJSONTransformer() -> NSValueTransformer {
        return ModelUtil<User>.transformer()
    }
    class func namespaceJSONTransformer() -> NSValueTransformer {
        return ModelUtil<Namespace>.transformer()
    }
    class func createdAtJSONTransformer() -> NSValueTransformer {
        return dateTimeTransformer
    }
    class func lastActivityAtJSONTransformer() -> NSValueTransformer {
        return dateTimeTransformer
    }
}