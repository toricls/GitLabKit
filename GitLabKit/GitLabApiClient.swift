//
//  GitLabApiClient.swift
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

public class GitLabApiClient {
    
    let host: String
    let privateToken: String
    
    let privateTokenKey: String = "private_token"
    
    init(host: String, privateToken: String) {
        assert(!host.isEmpty, "GitLabApiClient does not accept an empty host value.")
        assert(!privateToken.isEmpty, "GitLabApiClient does not accept an empty privateToken value.")
        
        // remove last '/' from the host string
        let length = countElements(host)
        self.host = (host[length-1] == "/" && length > 1) ? host[0...length-2] : host
        
        self.privateToken = privateToken
    }
    
    /**
    Fetch from API server with parameter builder
    
    :param: builder a parameter builder for the data model
    :param: handler callback handler for fetched data or error while requesting to your API server
    */
    public func get<T: GitLabModel where T: Fetchable>(builder: GitLabParamBuildable?, handler: ( GitLabResponse<T>?, NSError?) -> Void) {
        var params: [String:AnyObject]? = builder?.build()
        if params? == nil {
            params = [:]
        }
        params![self.privateTokenKey] = self.privateToken

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
    
    
    private func handleRawResponse<T: GitLabModel>(response: GitLabInternalResponse<T>, inout _ error: NSError?) -> [T]? {
        switch (response) {
        case .One(let result):
            return [result]
        case .Many(let results):
            return results
        case .Error(let err):
            if err!.code == 404 {
                error = nil
                return []
            }
            Logger.log(err!.localizedDescription)
            error = err
            return nil
        default:
            let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"Unimplemented Exception"]
            let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
            NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
        }
    }
}

// MARK: GitLabModel

public class GitLabModel: MTLModel, MTLJSONSerializing {
    public class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
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

import Alamofire
let GitLabKitErrorDomain = "io.orih.GitLabKit.error"

class GitLabApiEndPoint {
    
    func request<T: GitLabModel>(host: String, params: [String : AnyObject], handler:(response: GitLabInternalResponse<T>, linkObject: GitLabLinkObject?) -> Void) -> Void {
        
        let success: ((NSURLRequest, NSHTTPURLResponse?, AnyObject!) -> Void) = {
            // Extract and parse "Link" HTTP header
            var linkObj: GitLabLinkObject?
            if let link:AnyObject = $1?.allHeaderFields["Link"] {
                linkObj = GitLabLinkObject(link as? String)
            }
            handler(response: GitLabInternalResponse<T>.parse($2), linkObject: linkObj)
        }
        let failure: ((NSURLRequest, NSHTTPURLResponse?, NSError!) -> Void) = {
            handler(response: GitLabInternalResponse.Error($2), linkObject: nil)
        }
        
        
        let requestType: (path: String, fetchAsString: Bool) = self.buildPath(params, type: T.self)
        let request: Request = Alamofire.request(.GET, host + "/api/v3" + requestType.path, parameters: params)
        
        /**
        *  Handle the response and the error from API server.
        */
        if requestType.fetchAsString {
            request.responseString(completionHandler: { (request, response, string, error) -> Void in
                // Error in Alamofire
                if let resError = error {
                    failure(request, response, error)
                }
                
                // Error in GitLab API server
                var resultData: AnyObject? = string
                if let res: NSHTTPURLResponse = response {
                    switch(res.statusCode) {
                    case 200, 201: // OK, Created
                        break
                    default: // something went wrong...
                        Logger.log("Server returned error code: \(res.statusCode)")
                        var errorMsg: String = string? != nil ? string! : "failed to fetch raw content."
                        let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:errorMsg]
                        let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: res.statusCode, userInfo: userInfo)
                        failure(request, response, apiError)
                        return
                    }
                }
                
                // Succeed, resultData is not null.
                let data: AnyObject! = resultData
                success(request, response, data)
            })
        } else {
            request.responseJSON(options: NSJSONReadingOptions.MutableLeaves,
                completionHandler: { (request, response, json, error) -> Void in
                    // Error in Alamofire
                    if let resError = error {
                        failure(request, response, error)
                    }
                    
                    // Error in GitLab API server
                    var resultData: AnyObject? = json
                    if let res: NSHTTPURLResponse = response {
                        switch(res.statusCode) {
                        case 200, 201: // OK, Created
                            break
                        default: // something went wrong...
                            Logger.log("Server returned error code: \(res.statusCode)")
                            // Extract an error message
                            var errorMsg: String = ""
                            if let errorObj = json as? [NSObject: AnyObject] {
                                if let message = errorObj["message"] as? String {
                                    errorMsg = message
                                } else {
                                    errorMsg = errorObj.description
                                }
                            } else {
                                errorMsg = "We cannot handle error because of nothing understandable returned from API server."
                                Logger.log("\(errorMsg) See logs to solve this problem.")
                                Logger.log("Here is the response and recieved data:")
                                Logger.log(res)
                                Logger.log(json)
                            }
                            let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:errorMsg]
                            let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: res.statusCode, userInfo: userInfo)
                            failure(request, response, apiError)
                            return
                        }
                    }
                    
                    // Succeed, resultData is not null.
                    let data: AnyObject! = resultData
                    success(request, response, data)
            })
        }
    }
    
    private func buildPath<T: GitLabModel>(params: [String : AnyObject], type: T.Type) -> (path: String, fetchAsString: Bool) {
        var path: String = ""
        var fetchAsString: Bool = false
        switch(type.className().pathExtension) { // TODO: it's a bit hacky...
        case "User":
            if let myself = params["myself"] as? Bool {
                // To fetch information about myself
                path = "/user"
            } else {
                path = "/users"
                if let userId = params["id"] as? UInt {
                    path = "\(path)/\(userId)"
                }
            }
        case "UserFull":
            if let mine = params["mine"] as? Bool {
                // To fetch information about myself
                path = "/user"
            } else {
                // UserFull needs myself parameter
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"UserFull instance is available only for admin or private tokened user-self."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
        case "Project":
            path = "/projects"
            if let owned = params["owned"] as? Bool {
                path = "\(path)/owned"
            } else if let all = params["all"] as? Bool {
                path = "\(path)/all"
            } else if let projectId = params["id"] as? UInt {
                path = "\(path)/\(projectId)"
            } else if let namespace = params["namespaceAndName"] as? String {
                var encodedNamespace = self.getUriEncodedString(namespace)
                path = "\(path)/\(encodedNamespace)"
            }
            
            // TODO: orderBy, sort
        case "Member":
            var format = "/projects/%@/members"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else if let namespace = params["namespaceAndName"] as? String {
                let encodedNamespace = self.getUriEncodedString(namespace)
                path = String(format: format, encodedNamespace)
            } else {
                // we need projectId or project name+namespace for fetching project members.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId or a project name+namespace to fetch project members."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
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
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let milestoneId = params["id"] as? UInt {
                // single milestone
                path = "\(path)/\(milestoneId)"
            }
        case "Event":
            var format = "/projects/%@/events"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching milestones.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId to fetch milestones."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
        case "Snippet":
            var format = "/projects/%@/snippets"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching project snippets.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId or a project name+namespace to fetch project snippets."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let snippetId = params["snippetId"] as? UInt {
                // single snippet
                path = "\(path)/\(snippetId)"
                if let raw = params["rawData"] as? Bool {
                    path = "\(path)/raw"
                    fetchAsString = true
                }
            }
        case "SnippetContent":
            var format = "/projects/%@/snippets/%@/raw"
            var projectId: Any? = params["projectId"] as? UInt
            var snippetId: Any? = params["snippetId"] as? UInt
            
            switch (projectId, snippetId) {
            case let (pId as UInt, sId as UInt):
                path = String(format: format, String(pId), String(sId))
            default:
                // we need projectId or project name+namespace for fetching project snippet content.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId / a project name+namespace and snippetId to fetch project snippet content."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
            fetchAsString = true
        case "Hook":
            var format = "/projects/%@/hooks"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else if let namespace = params["namespaceAndName"] as? String {
                let encodedNamespace = self.getUriEncodedString(namespace)
                path = String(format: format, encodedNamespace)
            } else {
                // we need projectId or project name+namespace for fetching project members.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId or a project name+namespace to fetch project hooks."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let hookId = params["hookId"] as? UInt {
                // single hook
                path = "\(path)/\(hookId)"
            }
        case "Branch":
            var format = "/projects/%@/repository/branches"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else if let namespace = params["namespaceAndName"] as? String {
                let encodedNamespace = self.getUriEncodedString(namespace)
                path = String(format: format, encodedNamespace)
            } else {
                // we need projectId or project name+namespace for fetching project members.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId or a project name+namespace to fetch project branches."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let name = params["name"] as? UInt {
                path = "\(path)/\(name)"
            }
            
            // TODO: Protect/Unprotect single branch
        case "Tag":
            var format = "/projects/%@/repository/tags"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching tags.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId to fetch tags."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
        case "Tree":
            var format = "/projects/%@/repository/tags"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching tree.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId to fetch trees."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
        case "File":
            var format = "/projects/%@/repository/files"
            let projectId = params["projectId"] as UInt
            path = String(format: format, String(projectId))
        case "Commit":
            var format = "/projects/%@/repository/commits"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching commits.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId to fetch commits."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let sha = params["sha"] as? UInt {
                path = "\(path)/\(sha)"
            }
        case "MergeRequest":
            var format = "/projects/%@/merge_requests"
            if let projectId = params["projectId"] as? UInt {
                path = String(format: format, String(projectId))
            } else {
                // we need projectId or project name+namespace for fetching merge requests.
                let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a projectId to fetch merge requests."]
                let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            }
            
            if let state = params["state"] as? String {
                path = "\(path)?state=\(state)"
            }
            
            // TODO: orderBy, sort
            // TODO: single MR
        case "CommentForCommit":
            var format = "/projects/%@/repository/commits/%@/comments"
            let projectId = params["projectId"] as UInt
            let sha = params["sha"] as String
            path = String(format: format, String(projectId), sha)
        case "Diff":
            var format = "/projects/%@/repository/commits/%@/diff"
            let projectId = params["projectId"] as UInt
            let sha = params["sha"] as String
            path = String(format: format, String(projectId), sha)
        case "CommentForIssue":
            var format = "/projects/%@/issues/%@/notes"
            let projectId = params["projectId"] as UInt
            let issueId = params["issueId"] as UInt
            path = String(format: format, String(projectId), issueId)
            
            if let noteId = params["noteId"] as? UInt {
                path = "\(path)/\(noteId)"
            }
        case "CommentForSnippet":
            var format = "/projects/%@/snippets/%@/notes"
            let projectId = params["projectId"] as UInt
            let snippetId = params["snippetId"] as UInt
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
                if let issueId = params["issueId"] as? UInt {
                    // we need projectId or project name+namespace for fetching issues with its id.
                    let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"GitLab API needs a project id to fetch a single issue."]
                    let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -1, userInfo: userInfo)
                    NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
                }
            }
        default:
            let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"Unknown model class. It's a library bug or unimplemented."]
            let apiError: NSError = NSError(domain: GitLabKitErrorDomain, code: -99, userInfo: userInfo)
            NSException.raise("Exception", format:"Error: %@", arguments:getVaList([apiError]))
            break
        }
        return (path, fetchAsString)
    }
    
    private func getUriEncodedString(str: String) -> String {
        return str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

// MARK: GitLabInternalResponse

enum GitLabInternalResponse<T: GitLabModel> {
    case One(T)
    case Many([T])
    case Error(NSError?)
    
    static func parse<T: GitLabModel>(JSON: AnyObject) -> GitLabInternalResponse<T> {
        var error: NSError?
        
        if let object = JSON as? [NSObject: AnyObject] {
            if let x = MTLJSONAdapter.modelOfClass(T.self, fromJSONDictionary: object, error: &error) as? T {
                return .One(x)
            }
        } else if let array = JSON as? [AnyObject] {
            if let xs = MTLJSONAdapter.modelsOfClass(T.self, fromJSONArray: array, error: &error) as? [T] {
                return .Many(xs)
            }
        } else if let rawContent = JSON as? String {
            let jsonObject: [NSObject: AnyObject] = ["content": rawContent]
            if let x = MTLJSONAdapter.modelOfClass(T.self, fromJSONDictionary: jsonObject, error: &error) as? T {
                return .One(x)
            }
        }
        return .Error(error)
    }
}

// MARK: GeneralQueryParamBuilder, GitLabParamBuildable

public class GeneralQueryParamBuilder: GitLabParamBuildable {
    
    var params: [String:AnyObject] = ["page":"1", "per_page":"20"]
    
    func page(_ page: UInt = 1) -> Self {
        assert(page > 0, "GitLab API accepts a number greater than 0 as a page number.")
        params["page"] = page
        return self
    }
    func perPage(_ perPage: UInt = 20) -> Self {
        assert(perPage >= 0 && perPage <= 100, "GitLab API accepts a number 1 to 100 as a per_page value.") // 0 will be assumed as default value (20) on the API server side.
        params["per_page"] = perPage
        return self
    }
    
    public func build() -> [String:AnyObject]? {
        return params
    }
}

public protocol GitLabParamBuildable {
    /**
    *  Returns a dictionary includes query parameters. It's nullable.
    */
    func build() -> [String:AnyObject]?
}

public class GitLabLinkObject {
    
    private var pageForType: [LinkType:UInt] = [:]
    
    
    func has(type: LinkType) -> Bool {
        return self.pageForType[type] != nil
    }
    
    func getLink<T: GeneralQueryParamBuilder>(type: LinkType, prevParam: T) -> T? {
        if !self.has(type) {
            return nil
        }
        prevParam.page(self.pageForType[type]!)
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
    
    func parse(linkHeader: String!) -> [LinkType:UInt] {
        var result: [LinkType:UInt] = [:]
        // <https://git.supinf.co/api/v3/projects/owned?page=1&per_page=0>; rel="prev", <https://git.supinf.co/api/v3/projects/owned?page=3&per_page=0>; rel="next", <https://git.supinf.co/api/v3/projects/owned?page=1&per_page=0>; rel="first", <https://git.supinf.co/api/v3/projects/owned?page=3&per_page=0>; rel="last"
        let links: [String] = linkHeader.trim().componentsSeparatedByString(",")
        for link in links {
            // <https://git.supinf.co/api/v3/projects/owned?page=1&per_page=0>; rel="prev"
            var section: [String] = link.trim().componentsSeparatedByString(";")
            if (section.count != 2) {
                Logger.log("invalid link string. \(section)")
            }
            let url: String = section[0].trim().stringByReplacingOccurrencesOfString("^<|>$", withString:"", options:NSStringCompareOptions.RegularExpressionSearch, range: nil)
            let type: LinkType = LinkType(rawValue: section[1].trim().stringByReplacingOccurrencesOfString("^rel=\"|\"$", withString:"", options:NSStringCompareOptions.RegularExpressionSearch, range: nil))!
            
            if let urlObj = NSURLComponents(string: url) {
                for (var i=0; i < urlObj.queryItems?.count; i++) {
                    let item = urlObj.queryItems?[i] as NSURLQueryItem
                    if let value = item.value() {
                        if item.name == "page" {
                            result[type] = UInt(value.toInt()!)
                            break
                        }
                    }
                }
            }
        }
        return result
    }
}