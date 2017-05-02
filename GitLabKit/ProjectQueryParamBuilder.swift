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

open class ProjectQueryParamBuilder: GeneralQueryParamBuilder {
    
    open func id(_ id: UInt) -> Self {
        if params["id"] != nil || params["namespaceAndName"] != nil {
            return self
        }
        params["id"] = id as AnyObject
        return self
    }
    
    open func nameAndNamespace(_ name: String, namespace: String) -> Self {
        if params["id"] != nil || params["namespaceAndName"] != nil {
            return self
        }
        params["namespaceAndName"] = "\(namespace)/\(name)" as AnyObject
        return self
    }
    
    open func owned(_ owned: Bool) -> Self {
        params["owned"] = owned ? true as AnyObject? : nil as AnyObject?
        return self
    }
    
    open func archived(_ archived: Bool) -> Self {
        params["archived"] = archived ? "true" as AnyObject? : nil as AnyObject?
        return self
    }
    
    open func orderBy(_ order: ProjectOrderBy?) -> Self {
        params["order_by"] = order?.rawValue as AnyObject
        return self
    }
    
    open func sort(_ sort: ProjectSort?) -> Self {
        params["sort"] = sort?.rawValue as AnyObject
        return self
    }
    
    open func search(_ str: String) -> Self {
        params["search"] = str as AnyObject
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
