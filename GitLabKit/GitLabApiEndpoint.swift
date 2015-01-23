//
//  GitLabEndpoint.swift
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
import Alamofire
import Mantle

public let GitLabApiErrorDomain = "io.orih.GitLabKit.error"

enum GitLabApiEndpoint {
    case Users
    case UserById(id: UInt)
    case CurrentUser
    
    case Projects
    case ProjectById(id: UInt)
    case ProjectByName(nameWithNamespace: String)
    case ProjectMembers(projectId: UInt)
    case ProjectMembersByName(nameWithNamespace: String)
    
    case ProjectIssues(projectId: UInt)
    
    case Issues
    
    
    private func getRootEndpoint(host: String) -> String {
        return host + "/api/v3"
    }
    
    private func getRequestUrl(apiEndpoint: String, _ path: String) -> String {
        return apiEndpoint + path
    }
    
    private func getUriEncodedString(str: String) -> String {
        return str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    func request<T: MTLModel where T: MTLJSONSerializing>(host: String, parameters: [String: String]?, handler:(response: GitLabResponse<T>) -> Void) -> Void {
        let success: ((NSURLRequest, NSHTTPURLResponse?, AnyObject!) -> Void) = {
            handler(response: GitLabResponse<T>.parse($2))
        }
        let failure: ((NSURLRequest, NSHTTPURLResponse?, NSError!) -> Void) = {
            handler(response: GitLabResponse.Error($2))
        }
        
        let apiRoot: String = getRootEndpoint(host)
        var request: Request?
        
        // create request
        switch (self) {
        // Users
        case let .Users:
            request = Alamofire.request(.GET, self.getRequestUrl(apiRoot, "/users"), parameters: parameters)
        case let .UserById(id):
            request = Alamofire.request(.GET, self.getRequestUrl(apiRoot, "/users/\(id)"), parameters: parameters)
        case let .CurrentUser:
            request = Alamofire.request(.GET, self.getRequestUrl(apiRoot, "/user"), parameters: parameters)
        // Projects
        case let .Projects:
            request = Alamofire.request(.GET, self.getRequestUrl(apiRoot, "/projects"), parameters: parameters)
        case let .ProjectById(id):
            request = Alamofire.request(.GET, self.getRequestUrl(apiRoot, "/projects/\(id)"), parameters: parameters)
        case let .ProjectByName(nameWithNamespace):
            let path: String = self.getUriEncodedString(nameWithNamespace)
            request = Alamofire.request(.GET, self.getRequestUrl(apiRoot, "/projects/\(path)"), parameters: parameters)
        // Project Members
        case let .ProjectMembers(projectId):
            request = Alamofire.request(.GET, self.getRequestUrl(apiRoot, "/projects/\(projectId)/membres"), parameters: parameters)
        case let .ProjectMembersByName(nameWithNamespace):
            let path: String = self.getUriEncodedString(nameWithNamespace)
            request = Alamofire.request(.GET, self.getRequestUrl(apiRoot, "/projects/\(path)/members"), parameters: parameters)
        // Project Issues
        case let .ProjectIssues(projectId):
            request = Alamofire.request(.GET, self.getRequestUrl(apiRoot, "/projects/\(projectId)/issues"), parameters: parameters)
        // Issues
        case let .Issues:
            request = Alamofire.request(.GET, self.getRequestUrl(apiRoot, "/issues"), parameters: parameters)
        default:
            break
        }
        
        /**
        *  Handle the response and the error from API server.
        */
        request!.responseJSON(options: NSJSONReadingOptions.MutableLeaves,
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
                    default: // something wrong...
                        Logger.log("Server returns error code: \(res.statusCode)")
                        // Extract an error message
                        var errorMsg: String = ""
                        if let errorObj = json as? [NSObject: AnyObject] {
                            if let message = errorObj["message"] as? String {
                                errorMsg = message
                            } else {
                                errorMsg = errorObj.description
                            }
                        } else {
                            NSException.raise("Exception", format:"Error: %@", arguments:getVaList([error ?? "We cannot handle error because of nothing returned from API server."]))
                        }
                        let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:errorMsg]
                        let apiError: NSError = NSError(domain: GitLabApiErrorDomain, code: res.statusCode, userInfo: userInfo)
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