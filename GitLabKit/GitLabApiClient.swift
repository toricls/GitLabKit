//
//  GitLabApiClient.swift
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

open class GitLabApiClient {
    
    let host: String
    let privateToken: String
    
    let privateTokenKey: String = "private_token"
    
    init(host: String, privateToken: String) {
        assert(!host.isEmpty, "GitLabApiClient does not accept an empty host value.")
        assert(!privateToken.isEmpty, "GitLabApiClient does not accept an empty privateToken value.")
        
        // remove last '/' from the host string
        self.host = host.characters.last == "/" ? host.substring(to: host.index(before: host.endIndex)) : host
        
        self.privateToken = privateToken
    }
    
    /**
    Fetch from API server with parameter builder
    
    :param: builder a parameter builder for the data model
    :param: handler callback handler for fetched data or error while requesting to your API server
    */
    open func get<T: GitLabModel>(_ builder: GitLabParamBuildable?, handler: @escaping ( GitLabResponse<T>?, NSError?) -> Void) where T: Fetchable {
        var params: [String:AnyObject]? = builder?.build()
        if params == nil {
            params = [:]
        }
        params![self.privateTokenKey] = self.privateToken as AnyObject

        GitLabApiEndPoint().request(self.host, params: params!, handler: { (response: GitLabInternalResponse<T>, linkObject: GitLabLinkObject?) -> Void in
            var error: NSError?
            let resultArray = self.handleRawResponse(response, &error)
            let result: GitLabResponse = GitLabResponse(resultArray: resultArray, linkObject: linkObject)
            handler(result, error)
        })
    }
    
    // public func create //Creatable //AdminCreatable??
    // public func update //Updatable
    // public func deletable //Deletable
    
    
    fileprivate func handleRawResponse<T: GitLabModel>(_ response: GitLabInternalResponse<T>, _ error: inout NSError?) -> [T]? {
        switch (response) {
        case .one(let result):
            return [result]
        case .many(let results):
            return results
        case .error(let err):
            if err!.code == 404 {
                error = nil
                return []
            }
            Logger.log(err!.localizedDescription as AnyObject)
            error = err
            return nil
//        default:
//            let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"Unimplemented Exception"]
//            let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
//            NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
        }
    }
}

// MARK: GitLabModel

open class GitLabModel: MTLModel, MTLJSONSerializing {
    open class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any]! {
        return [:]
    }
}

public protocol Fetchable {
}
public protocol RawDataFetchable { // For Snippet
    var content: String? { get set }
}
public protocol Creatable {
}
public protocol Editable {
}
public protocol Deletable {
}

// MARK: GitLabApiEndPoint

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

import Cocoa
import Alamofire

let GitLabKitErrorDomain = "io.orih.GitLabKit.error"

class GitLabApiEndPoint {
    
    func request<T: GitLabModel>(_ host: String, params: [String : AnyObject], handler:@escaping (_ response: GitLabInternalResponse<T>, _ linkObject: GitLabLinkObject?) -> Void) -> Void {
        
        let success: ((URLRequest, HTTPURLResponse?, AnyObject?) -> Void) = {
            // Extract and parse "Link" HTTP header
            var linkObj: GitLabLinkObject?
            if let link = $1?.allHeaderFields["Link"] as? String {
                linkObj = GitLabLinkObject(link)
            }
            handler(GitLabInternalResponse<T>.parse($2!), linkObj)
        }
        let failure: ((URLRequest, HTTPURLResponse?, NSError?) -> Void) = {
            handler(GitLabInternalResponse.error($2), nil)
        }
        
        
        let requestType: (path: String, fetchAsString: Bool) = self.buildPath(params, type: T.self)
        guard var url = URL(string: host) else {
            return
        }
        
        url = url.appendingPathComponent("api").appendingPathComponent("v3").appendingPathComponent(requestType.path)
        
        let request = Alamofire.request(url, method: .get, parameters: params)
        
        /**
        *  Handle the response and the error from API server.
        */
        if requestType.fetchAsString {
            request.responseString(completionHandler: { (response) in
                // Error in Alamofire
                if let resError = response.error {
                    failure(response.request!, response.response, resError as NSError)
                }
                
                // Error in GitLab API server
//                let resultData = response.value
                if let res = response.response {
                    switch(res.statusCode) {
                    case 200, 201: // OK, Created
                        break
                    default: // something went wrong...
                        Logger.log("Server returned error code: \(res.statusCode)" as AnyObject)
                        let errorMsg : String = response.value ?? "failed to fetch raw content."
                        let userInfo : [AnyHashable : Any] = [NSLocalizedDescriptionKey:errorMsg]
                        let apiError : NSError = NSError(domain: GitLabKitErrorDomain, code: res.statusCode, userInfo: userInfo)
                        failure(response.request!, response.response, apiError)
                        return
                    }
                }
                
                // Succeed, resultData is not null.
                guard let data = response.value else { return }
                success(response.request!, response.response, data as AnyObject)
            })
        } else {
            request.responseJSON(options: JSONSerialization.ReadingOptions.mutableLeaves,
                completionHandler: { (response) in
                    // Error in Alamofire
                    if let resError = response.error {
                        failure(response.request!, response.response!, resError as NSError)
                    }
                    
                    // Error in GitLab API server
                    let resultData = response.value
                    if let res = response.response {
                        switch(res.statusCode) {
                        case 200, 201: // OK, Created
                            break
                        default: // something went wrong...
                            Logger.log("Server returned error code: \(res.statusCode)" as AnyObject)
                            // Extract an error message
                            var errorMsg: String = ""
                            if let errorObj = resultData as? [AnyHashable: Any] {
                                if let message = errorObj["message"] as? String {
                                    errorMsg = message
                                } else {
                                    errorMsg = errorObj.description
                                }
                            } else {
                                errorMsg = "We cannot handle error because of nothing understandable returned from API server."
                                Logger.log("\(errorMsg) See logs to solve this problem." as AnyObject)
                                Logger.log("Here is the response and recieved data:" as AnyObject)
                                Logger.log(res)
                                Logger.log(response.value as AnyObject)
                            }
                            let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:errorMsg]
                            let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: res.statusCode, userInfo: userInfo as? [AnyHashable : Any])
                            failure(response.request!, response.response, apiError)
                            return
                        }
                    }
                    
                    // Succeed, resultData is not null.
                    guard let data = resultData else { return }
                    success(response.request!, response.response, data as AnyObject)
            })
        }
    }
    
    fileprivate func buildPath<T: GitLabModel>(_ params: [String : AnyObject], type: T.Type) -> (path: String, fetchAsString: Bool) {
        var path: String = ""
        var fetchAsString: Bool = false
        
        switch((type.className() as NSString).pathExtension) { // TODO: it's a bit hacky...
        case "User":
            if let myself = params["myself"] as? Bool, myself {
                // To fetch information about myself
                path = "/user"
            } else {
                path = "/users"
                if let userId = params["id"] as? UInt {
                    path = "\(path)/\(userId)"
                }
            }
        case "UserFull":
            if let mine = params["mine"] as? Bool, mine {
                // To fetch information about myself
                path = "/user"
            } else {
                // UserFull needs myself parameter
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"UserFull instance is available only for admin or private tokened user-self."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
        case "Project":
            path = "/projects"
            if let owned = params["owned"] as? Bool, owned {
                path = "\(path)/owned"
            } else if let all = params["all"] as? Bool, all {
                path = "\(path)/all"
            } else if let projectId = params["id"] as? UInt {
                path = "\(path)/\(projectId)"
            } else if let namespace = params["namespaceAndName"] as? String {
                let encodedNamespace = self.getUriEncodedString(namespace)
                path = "\(path)/\(encodedNamespace)"
            }
            
            // TODO: orderBy, sort
        case "Member":
            let format = "/projects/%@/members"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else if let namespace = params["namespaceAndName"] as? String {
                let encodedNamespace = self.getUriEncodedString(namespace)
                path = String(format: format, encodedNamespace)
            } else {
                // we need projectId or project name+namespace for fetching project members.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId or a project name+namespace to fetch project members."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let userId = params["userId"] as? UInt {
                // single member
                path = "\(path)/\(userId)"
            }
        case "Milestone":
            path = "/milestones"
            if let projectId = params["projectId"] as? UInt {
                path = "/projects/\(projectId)\(path)"
            } else {
                // we need projectId or project name+namespace for fetching milestones.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId or a project name+namespace to fetch milestones."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let milestoneId = params["id"] as? UInt {
                // single milestone
                path = "\(path)/\(milestoneId)"
            }
        case "Event":
            let format = "/projects/%@/events"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching milestones.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId to fetch milestones."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
        case "Snippet":
            let format = "/projects/%@/snippets"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching project snippets.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId or a project name+namespace to fetch project snippets."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let snippetId = params["snippetId"] as? UInt {
                // single snippet
                path = "\(path)/\(snippetId)"
                if let raw = params["rawData"] as? Bool, raw {
                    path = "\(path)/raw"
                    fetchAsString = true
                }
            }
        case "SnippetContent":
            let format = "/projects/%@/snippets/%@/raw"
            let projectId: Any? = params["projectId"] as? UInt
            let snippetId: Any? = params["snippetId"] as? UInt
            
            switch (projectId, snippetId) {
            case let (pId as UInt, sId as UInt):
                path = String(format: format, String(pId), String(sId))
            default:
                // we need projectId or project name+namespace for fetching project snippet content.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId / a project name+namespace and snippetId to fetch project snippet content."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
            fetchAsString = true
        case "Hook":
            let format = "/projects/%@/hooks"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else if let namespace = params["namespaceAndName"] as? String {
                let encodedNamespace = self.getUriEncodedString(namespace)
                path = String(format: format, encodedNamespace)
            } else {
                // we need projectId or project name+namespace for fetching project members.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId or a project name+namespace to fetch project hooks."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let hookId = params["hookId"] as? UInt {
                // single hook
                path = "\(path)/\(hookId)"
            }
        case "Branch":
            let format = "/projects/%@/repository/branches"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else if let namespace = params["namespaceAndName"] as? String {
                let encodedNamespace = self.getUriEncodedString(namespace)
                path = String(format: format, encodedNamespace)
            } else {
                // we need projectId or project name+namespace for fetching project members.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId or a project name+namespace to fetch project branches."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let name = params["name"] as? UInt {
                path = "\(path)/\(name)"
            }
            
            // TODO: Protect/Unprotect single branch
        case "Tag":
            let format = "/projects/%@/repository/tags"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching tags.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId to fetch tags."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
        case "Tree":
            let format = "/projects/%@/repository/tags"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching tree.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId to fetch trees."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
        case "File":
            let format = "/projects/%@/repository/files"
            let projectId = params["projectId"] as! UInt
            path = String(format: format, String(projectId))
        case "Commit":
            let format = "/projects/%@/repository/commits"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching commits.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId to fetch commits."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let sha = params["sha"] as? UInt {
                path = "\(path)/\(sha)"
            }
        case "MergeRequest":
            let format = "/projects/%@/merge_requests"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching merge requests.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId to fetch merge requests."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let state = params["state"] as? String {
                path = "\(path)?state=\(state)"
            }
            
            // TODO: orderBy, sort
            // TODO: single MR
        case "CommentForCommit":
            let format = "/projects/%@/repository/commits/%@/comments"
            let projectId = params["projectId"] as! UInt
            let sha = params["sha"] as! String
            path = String(format: format, String(projectId), sha)
        case "Diff":
            let format = "/projects/%@/repository/commits/%@/diff"
            let projectId = params["projectId"] as! UInt
            let sha = params["sha"] as! String
            path = String(format: format, String(projectId), sha)
        case "CommentForIssue":
            let format = "/projects/%@/issues/%@/notes"
            let projectId = params["projectId"] as! UInt
            let issueId = params["issueId"] as! UInt
            path = String(format: format, String(projectId), issueId)
            
            if let noteId = params["noteId"] as? UInt {
                path = "\(path)/\(noteId)"
            }
        case "CommentForSnippet":
            let format = "/projects/%@/snippets/%@/notes"
            let projectId = params["projectId"] as! UInt
            let snippetId = params["snippetId"] as! UInt
            path = String(format: format, String(projectId), snippetId)
            
            if let noteId = params["noteId"] as? UInt {
                path = "\(path)/\(noteId)"
            }
        case "Issue":
            path = "/issues"
            if let projectId = params["projectId"] as? UInt {
                // This request is expecting to fetch project tag(s).
                path = "/projects/\(projectId)\(path)"
                if let issueId = params["issueId"] as? UInt {
                    path = "\(path)/\(issueId)"
                }
            } else {
                if let _ = params["issueId"] as? UInt {
                    // we need projectId or project name+namespace for fetching issues with its id.
                    let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a project id to fetch a single issue."]
                    let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo as? [AnyHashable : Any])
                    NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
                }
            }
        default:
            let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"Unknown model class. It's a library bug or unimplemented."]
            let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -99, userInfo: userInfo as? [AnyHashable : Any])
            NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Error: %@", arguments:getVaList([apiError]))
            break
        }
        return (path, fetchAsString)
    }
    
    fileprivate func getUriEncodedString(_ str: String) -> String {
        return str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

// MARK: GitLabInternalResponse

enum GitLabInternalResponse<T: GitLabModel> {
    case one(T)
    case many([T])
    case error(NSError?)
    
    static func parse<T: GitLabModel>(_ JSON: AnyObject) -> GitLabInternalResponse<T> {
        var error: NSError?

        if let object = JSON as? [AnyHashable: Any] {
            if let x =  MTLJSONAdapter.model(of: T.self, fromJSONDictionary: object) as? T {
                return .one(x)
            }
        } else if let array = JSON as? [AnyObject] {
            do {
                if let xs = try MTLJSONAdapter.models(of: T.self, fromJSONArray: array) as? [T] {
                    return .many(xs)
                }
            } catch let e as NSError {
                error = e
            }
        } else if let rawContent = JSON as? String {
            let jsonObject: [AnyHashable: Any] = ["content": rawContent]
            
            if let x =  MTLJSONAdapter.model(of: T.self, fromJSONDictionary: jsonObject) as? T {
                return .one(x)
            }
        }
        return .error(error)
    }
}

// MARK: GeneralQueryParamBuilder, GitLabParamBuildable

open class GeneralQueryParamBuilder: GitLabParamBuildable {
    
    var params: [String:AnyObject] = ["page":"1" as AnyObject, "per_page":"20" as AnyObject]
    
    func page(_ page: UInt = 1) -> Self {
        assert(page > 0, "GitLab API accepts a number greater than 0 as a page number.")
        params["page"] = page as AnyObject
        return self
    }
    func perPage(_ perPage: UInt = 20) -> Self {
        assert(perPage >= 0 && perPage <= 100, "GitLab API accepts a number 1 to 100 as a per_page value.") // 0 will be assumed as default value (20) on the API server side.
        params["per_page"] = perPage as AnyObject
        return self
    }
    
    open func build() -> [String:AnyObject]? {
        return params
    }
}

public protocol GitLabParamBuildable {
    /**
    *  Returns a dictionary includes query parameters. It's nullable.
    */
    func build() -> [String:AnyObject]?
}

open class GitLabLinkObject {
    
    fileprivate var pageForType: [LinkType:UInt] = [:]
    
    
    func has(_ type: LinkType) -> Bool {
        return self.pageForType[type] != nil
    }
    
    func getLink<T: GeneralQueryParamBuilder>(_ type: LinkType, prevParam: T) -> T? {
        if !self.has(type) {
            return nil
        }
        _ = prevParam.page(self.pageForType[type]!)
        return prevParam
    }
    
    init(_ linkHeader: String?) {
        self.pageForType = parse(linkHeader)
    }
    
    enum LinkType: String {
        case Next = "next"
        case Prev = "prev"
        case First = "first"
        case Last = "last"
    }
    
    func parse(_ linkHeader: String!) -> [LinkType:UInt] {
        var result: [LinkType:UInt] = [:]
        // <https://git.supinf.co/api/v3/projects/owned?page=1&per_page=0>; rel="prev", <https://git.supinf.co/api/v3/projects/owned?page=3&per_page=0>; rel="next", <https://git.supinf.co/api/v3/projects/owned?page=1&per_page=0>; rel="first", <https://git.supinf.co/api/v3/projects/owned?page=3&per_page=0>; rel="last"
        let links: [String] = linkHeader.trim().components(separatedBy: ",")
        for link in links {
            // <https://git.supinf.co/api/v3/projects/owned?page=1&per_page=0>; rel="prev"
            var section: [String] = link.trim().components(separatedBy: ";")
            if (section.count != 2) {
                Logger.log("invalid link string. \(section)" as AnyObject)
            }
            let url: String = section[0].trim().replacingOccurrences(of: "^<|>$", with:"", options:NSString.CompareOptions.regularExpression, range: nil)
            let type: LinkType = LinkType(rawValue: section[1].trim().replacingOccurrences(of: "^rel=\"|\"$", with:"", options:NSString.CompareOptions.regularExpression, range: nil))!
            
            if let items = URLComponents(string: url)?.queryItems {
                for item in items {
                    if let value = item.value {
                        if item.name == "page" {
                            result[type] = UInt(value)
                            break
                        }
                    }
                }
            }
        }
        return result
    }
}
