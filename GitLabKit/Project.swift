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

open class Project: GitLabModel, Fetchable, Creatable, Editable, Deletable {
    
    open var id: NSNumber?
    open var descriptionText: String? // "description" as a property name is not allowed by compiler
    open var defaultBranch: String?
    open var _isPublic: NSNumber?
    open var isPublic: Bool {
        get { return _isPublic != nil ? _isPublic!.boolValue : false }
        set { _isPublic = NSNumber(value: newValue as Bool)}
    }
    open var visibilityLevel: NSNumber?
    open var sshUrlToRepo: String?
    open var httpUrlToRepo: String?
    open var webUrl: String?
    open var owner: User?
    open var name: String?
    open var nameWithNamespace: String?
    open var path: String?
    open var pathWithNamespace: String?
    open var _issuesEnabled: NSNumber?
    open var issuesEnabled: Bool {
        get { return _issuesEnabled != nil ? _issuesEnabled!.boolValue : false }
        set { _issuesEnabled = NSNumber(value: newValue as Bool)}
    }
    open var _mergeRequestsEnabled: NSNumber?
    open var mergeRequestsEnabled: Bool {
        get { return _mergeRequestsEnabled != nil ? _mergeRequestsEnabled!.boolValue : false }
        set { _mergeRequestsEnabled = NSNumber(value: newValue as Bool)}
    }
    open var _wikiEnabled: NSNumber?
    open var wikiEnabled: Bool {
        get { return _wikiEnabled != nil ? _wikiEnabled!.boolValue : false }
        set { _wikiEnabled = NSNumber(value: newValue as Bool)}
    }
    open var _snippetsEnabled: NSNumber?
    open var snippetsEnabled: Bool {
        get { return _snippetsEnabled != nil ? _snippetsEnabled!.boolValue : false }
        set { _snippetsEnabled = NSNumber(value: newValue as Bool)}
    }
    open var createdAt: Date?
    open var lastActivityAt: Date?
    open var namespace: Namespace?
    open var _archived: NSNumber?
    open var archived: Bool {
        get { return _archived != nil ? _archived!.boolValue : false }
        set { _archived = NSNumber(value: newValue as Bool)}
    }
    
    open override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        let baseKeys: [AnyHashable: Any] = super.jsonKeyPathsByPropertyKey()
        let newKeys: [AnyHashable: Any] = [
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
    
    class func ownerJSONTransformer() -> ValueTransformer {
        return ModelUtil<User>.transformer()
    }
    class func namespaceJSONTransformer() -> ValueTransformer {
        return ModelUtil<Namespace>.transformer()
    }
    class func createdAtJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
    class func lastActivityAtJSONTransformer() -> ValueTransformer {
        return dateTimeTransformer
    }
}
