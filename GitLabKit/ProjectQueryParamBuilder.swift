//
//  ProjectQueryParamBuilder.swift
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

public class ProjectQueryParamBuilder: GeneralQueryParamBuilder, GitLabParamBuildable {
    
    public func id(id: UInt) -> Self {
        if params["id"]? != nil || params["namespaceAndName"]? != nil {
            return self
        }
        params["id"] = id
        return self
    }
    
    public func nameAndNamespace(name: String, namespace: String) -> Self {
        if params["id"]? != nil || params["namespaceAndName"]? != nil {
            return self
        }
        params["namespaceAndName"] = "\(namespace)/\(name)"
        return self
    }
    
    public func owned(owned: Bool) -> Self {
        params["owned"] = owned ? true : nil
        return self
    }
    
    public func archived(archived: Bool) -> Self {
        params["archived"] = archived ? "true" : nil
        return self
    }
    
    public func orderBy(order: ProjectOrderBy?) -> Self {
        params["order_by"] = order? == nil ? nil : order!.rawValue
        return self
    }
    
    public func sort(sort: ProjectSort?) -> Self {
        params["sort"] = sort? == nil ? nil : sort!.rawValue
        return self
    }
    
    public func search(str: String) -> Self {
        params["search"] = str
        return self
    }    
}

public enum ProjectOrderBy: String {
    case Id = "id"
    case Name = "name"
    case CreatedAt = "created_at"
    case LastActivityAt = "last_activity_at"
}

public enum ProjectSort: String {
    case Asc = "asc"
    case Desc = "desc"
}