//
//  UserFull.swift
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

public class UserFull: User {
    public var createdAt: NSDate?
    public var _isAdmin: NSNumber?
    public var bio: String?
    public var skype: String?
    public var linkedin: String?
    public var twitter: String?
    public var websiteUrl: String?
    public var email: String?
    public var themeId: NSNumber?
    public var colorSchemeId: NSNumber?
    public var externUid: String?
    public var provider: String?
    public var projectsLimit: NSNumber?
    public var _canCreateGroup: NSNumber?
    public var _canCreateProject: NSNumber?
    public var privateToken: String?
    
    public var isAdmin: Bool {
        get { return _isAdmin? != nil ? _isAdmin!.boolValue : false }
        set { _isAdmin = NSNumber(bool: newValue)}
    }
    public var canCreateGroup: Bool {
        get { return _canCreateGroup? != nil ? _canCreateGroup!.boolValue : false }
        set { _canCreateGroup = NSNumber(bool: newValue)}
    }
    public var canCreateProject: Bool {
        get { return _canCreateProject? != nil ? _canCreateProject!.boolValue : false }
        set { _canCreateProject = NSNumber(bool: newValue)}
    }
    
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
            "createdAt"         : "created_at",
            "_isAdmin"          : "is_admin",
            "bio"               : "bio",
            "skype"             : "skype",
            "linkedin"          : "linkedin",
            "twitter"           : "twitter",
            "websiteUrl"        : "website_url",
            "email"             : "email",
            "themeId"           : "theme_id",
            "colorSchemeId"     : "color_scheme_id",
            "externUid"         : "extern_uid",
            "provider"          : "provider",
            "projectsLimit"     : "projects_limit",
            "_canCreateGroup"   : "can_create_group",
            "_canCreateProject" : "can_create_project",
            "privateToken"      : "private_token"
        ]
        return baseKeys + newKeys
    }
    
    class func createdAtJSONTransformer() -> NSValueTransformer {
        return dateTimeTransformer
    }
}