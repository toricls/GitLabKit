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
    
    init(host: String, privateToken: String) {
        assert(!host.isEmpty, "GitLabApiClient does not accept empty host value.")
        assert(!privateToken.isEmpty, "GitLabApiClient does not accept empty privateToken value.")
        self.host = host
        self.privateToken = privateToken
    }
    
    private func handleResponse<T: MTLModel where T: MTLJSONSerializing>(response: GitLabResponse<T>, inout _ error: NSError?) -> [T]? {
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
            let userInfo: NSMutableDictionary = [NSLocalizedDescriptionKey:"Invalid operation"]
            error = NSError(domain: GitLabApiErrorDomain, code: -1, userInfo: userInfo)
            return nil
        }
    }

// MARK: - Users
    
    /**
    Retrieve users.
    
    :param: callback a Handler for an array of GitLabUserBasic instances. If an error exists, array can be nil.
    */
    public func getUsers(callback: ([GitLabUserBasic]?, NSError?) -> Void) {
        var parameters = ["private_token": self.privateToken]
        GitLabApiEndpoint.Users.request(self.host, parameters: parameters, handler: { (response: GitLabResponse<GitLabUserBasic>) in
            var error: NSError?
            let result = self.handleResponse(response, &error)
            callback(result, error)
        })
    }
    
    /**
    Retrieve an user specified by userid.
    
    :param: callback handler for an array includes a GitLabUserBasic instance. If an error exists, array can be nil.
    */
    public func getUser(id: UInt, callback: ([GitLabUserBasic]?, NSError?) -> Void) {
        var parameters = ["private_token": self.privateToken]
        GitLabApiEndpoint.UserById(id: id).request(self.host, parameters: parameters, handler: { (response: GitLabResponse<GitLabUserBasic>) in
            var error: NSError?
            let result = self.handleResponse(response, &error)
            callback(result, error)
        })
    }
    
    /**
    Retrieve a current(private token) user.
    
    :param: callback handler for an array includes a GitLabUserFull instance. If an error exists, array can be nil.
    */
    public func getCurrentUser(callback: ([GitLabUserFull]?, NSError?) -> Void) {
        var parameters = ["private_token": self.privateToken]
        GitLabApiEndpoint.CurrentUser.request(self.host, parameters: parameters, handler: { (response: GitLabResponse<GitLabUserFull>) in
            var error: NSError?
            let result = self.handleResponse(response, &error)
            callback(result, error)
        })
    }

// MARK: - Projects
    
    /**
    Retrieve projects.
    
    :param: callback a Handler for an array of GitLabUserProject instances. If an error exists, array can be nil.
    */
    public func getProjects(callback: ([GitLabProject]?, NSError?) -> Void) {
        var parameters = ["private_token": self.privateToken]
        GitLabApiEndpoint.Projects.request(self.host, parameters: parameters, handler: { (response: GitLabResponse<GitLabProject>) in
            var error: NSError?
            let result = self.handleResponse(response, &error)!
            callback(result, error)
        })
    }
    
    /**
    Retrieve a project specified by projectid.
    
    :param: callback a Handler for an array includes a GitLabProject instance. If an error exists, array can be nil.
    */
    public func getProject(id: UInt, callback: ([GitLabProject]?, NSError?) -> Void) {
        var parameters = ["private_token": self.privateToken]
        GitLabApiEndpoint.ProjectById(id: id).request(self.host, parameters: parameters, handler: { (response: GitLabResponse<GitLabProject>) in
            var error: NSError?
            let result = self.handleResponse(response, &error)!
            callback(result, error)
        })
    }
    
    /**
    Retrieve a project specified by project name and its namespace.
    
    :param: callback a Handler for an array includes a GitLabProject instance. If an error exists, array can be nil.
    */
    public func getProject(namespace: String, name: String, callback: ([GitLabProject]?, NSError?) -> Void) {
        var parameters = ["private_token": self.privateToken]
        GitLabApiEndpoint.ProjectByName(nameWithNamespace: namespace + "/" + name).request(self.host, parameters: parameters, handler: { (response: GitLabResponse<GitLabProject>) in
            var error: NSError?
            let result = self.handleResponse(response, &error)!
            callback(result, error)
        })
    }

// MARK: - Project Members

    /**
    Retrieve project members specified by project id.
    
    :param: callback a Handler for an array of GitLabProjectMember instances. If an error exists, array can be nil.
    */
    public func getProjectMembers(projectId: UInt, callback: ([GitLabProjectMember]?, NSError?) -> Void) {
        var parameters = ["private_token": self.privateToken]
        GitLabApiEndpoint.ProjectMembers(projectId: projectId).request(self.host, parameters: parameters, handler: { (response: GitLabResponse<GitLabProjectMember>) in
            var error: NSError?
            let result = self.handleResponse(response, &error)
            callback(result, error)
        })
    }
    
    /**
    Retrieve project members specified by project name and its namespace.
    
    :param: callback a Handler for an array of GitLabProjectMember instances. If an error exists, array can be nil.
    */
    public func getProjectMembers(projectNamespace: String, projectName: String, callback: ([GitLabProjectMember]?, NSError?) -> Void) {
        var parameters = ["private_token": self.privateToken]
        GitLabApiEndpoint.ProjectMembersByName(nameWithNamespace: projectNamespace + "/" + projectName).request(self.host, parameters: parameters, handler: { (response: GitLabResponse<GitLabProjectMember>) in
            var error: NSError?
            let result = self.handleResponse(response, &error)
            callback(result, error)
        })
    }

// MARK: - Project Issues
    
    /**
    Retrieve project issues specified by project id.
    
    :param: callback a Handler for an array of GitLabIssue instances. If an error exists, array can be nil.
    */
    public func getProjectIssues(projectId: UInt, callback: ([GitLabIssue]?, NSError?) -> Void) {
        var parameters = ["private_token": self.privateToken]
        GitLabApiEndpoint.ProjectIssues(projectId: projectId).request(self.host, parameters: parameters, handler: { (response: GitLabResponse<GitLabIssue>) in
            var error: NSError?
            let result = self.handleResponse(response, &error)
            callback(result, error)
        })
    }
    
// MARK: - Issues
    
    /**
    Retrieve issues.
    
    :param: callback handler for an array of GitLabIssue instances. If an error exists, array can be nil.
    */
    public func getIssues(callback: ([GitLabIssue]?, NSError?) -> Void) {
        var parameters = ["private_token": self.privateToken]
        GitLabApiEndpoint.Issues.request(self.host, parameters: parameters, handler: { (response: GitLabResponse<GitLabIssue>) in
            var error: NSError?
            let result = self.handleResponse(response, &error)
            callback(result, error)
        })
    }
    
}