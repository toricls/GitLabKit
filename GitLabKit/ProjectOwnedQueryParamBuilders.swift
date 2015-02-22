//
//  ProjectOwnedQueryParamBuilders.swift
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

public class ProjectOwnedQueryParamBuilder: GeneralQueryParamBuilder, GitLabParamBuildable {
    
    init(projectId: UInt) {
        super.init()
        params["projectId"] = projectId
    }
    init(projectName: String, namespace: String) {
        super.init()
        params["namespaceAndName"] = "\(namespace)/\(projectName)"
    }
    
}

// MARK: ProjectIssues

public class ProjectIssueQueryParamBuilder : IssueQueryParamBuilder {
    init(projectId: UInt) {
        super.init()
        params["projectId"] = projectId
    }
    init(projectName: String, namespace: String) {
        super.init()
        params["namespaceAndName"] = "\(namespace)/\(projectName)"
    }
    
    public func issueId(issueId: UInt) -> Self {
        if params["issueId"]? != nil {
            return self
        }
        params["issueId"] = issueId
        return self
    }
    
    public func milestone(milestone: String) -> Self {
        if !milestone.isEmpty {
            params["milestone"] = milestone.trim()
        }
        return self
    }
}

// MARK: ProjectMembers

public class ProjectMemberQueryParamBuilder : ProjectOwnedQueryParamBuilder {
    public func userId(userId: UInt) -> Self {
        if params["userId"]? != nil {
            return self
        }
        params["userId"] = userId
        return self
    }
}

// MARK: ProjectEvents

public class ProjectEventQueryParamBuilder: ProjectOwnedQueryParamBuilder {}

// MARK: ProjectMergeRequests

public class ProjectMergeRequestQueryParamBuilder: ProjectOwnedQueryParamBuilder {
    
    public func state(state: MergeRequestState) -> Self {
        params["state"] = state.rawValue
        return self
    }
    
    public func orderBy(order: MergeRequestOrderBy?) -> Self {
        params["order_by"] = order? == nil ? nil : order!.rawValue
        return self
    }
    
    public func sort(sort: MergeRequestSort?) -> Self {
        params["sort"] = sort? == nil ? nil : sort!.rawValue
        return self
    }
    
}

// MARK: ProjectBranches

public class ProjectBranchQueryParamBuilder : ProjectOwnedQueryParamBuilder {
    public func branchName(name: String) -> Self {
        if params["name"]? != nil {
            return self
        }
        params["name"] = name
        return self
    }
}

// MARK: ProjectHooks

public class ProjectHookQueryParamBuilder: ProjectOwnedQueryParamBuilder {
    public func hookId(hookId: UInt) -> Self {
        if params["hookId"]? != nil {
            return self
        }
        params["hookId"] = hookId
        return self
    }
}

// MARK: ProjectSnippets

public class ProjectSnippetQueryParamBuilder: ProjectOwnedQueryParamBuilder {
    public func snippetId(snippetId: UInt) -> Self {
        if params["snippetId"]? != nil {
            return self
        }
        params["snippetId"] = snippetId
        return self
    }
}

// MARK: ProjectFiles

public class ProjectFileQueryParamBuilder: GeneralQueryParamBuilder, GitLabParamBuildable {
    /**
    initializer
    
    :param: projectId
    :param: filePath  Full path to new file. Ex. lib/class.rb
    :param: ref       The name of branch, tag or commit
    
    :returns: ProjectFileQueryParamBuilder
    */
    init(projectId: UInt, filePath: String, ref: String) {
        super.init()
        params["projectId"] = projectId
        params["file_path"] = filePath
        params["ref"] = ref
    }
    init(projectName: String, namespace: String, filePath: String, ref: String) {
        super.init()
        params["namespaceAndName"] = "\(namespace)/\(projectName)"
        params["file_path"] = filePath
        params["ref"] = ref
    }
}

// MARK: ProjectTags

public class ProjectTagQueryParamBuilder: ProjectOwnedQueryParamBuilder {}

// MARK: ProjectTrees

public class ProjectTreeQueryParamBuilder: ProjectOwnedQueryParamBuilder {
    /**
    Specify the path inside repository
    
    :param: path The path inside repository. Used to get contend of subdirectories
    */
    public func path(path: String) -> Self {
        params["path"] = path
        return self
    }
    
    /**
    Specify the name of a repository branch or tag
    
    :param: refName The name of a repository branch or tag or if not given the default branch
    */
    public func refName(refName: String) -> Self {
        params["refName"] = refName
        return self
    }
}

// MARK: ProjectCommits

public class ProjectCommitQueryParamBuilder: ProjectOwnedQueryParamBuilder {
    /**
    Specify the name of a repository branch or tag
    
    :param: refName The name of a repository branch or tag or if not given the default branch
    */
    public func refName(refName: String) -> Self {
        params["refName"] = refName
        return self
    }
    
    public func sha(sha: String) -> Self {
        params["sha"] = sha
        return self
    }
}

// MARK: Comment For ProjectCommits

public class ProjectCommentForCommitQueryParamBuilder: GeneralQueryParamBuilder, GitLabParamBuildable {
    init(projectId: UInt, commitSha: String) {
        super.init()
        params["projectId"] = projectId
        params["sha"] = commitSha
    }
    init(projectName: String, namespace: String, commitSha: String) {
        super.init()
        params["namespaceAndName"] = "\(namespace)/\(projectName)"
        params["sha"] = commitSha
    }
}

// MARK: Comment For ProjectIssues

public class ProjectCommentForIssueQueryParamBuilder : IssueQueryParamBuilder {
    init(projectId: UInt, issueId: UInt) {
        super.init()
        params["projectId"] = projectId
        params["issueId"] = issueId
    }
    init(projectName: String, namespace: String, issueId: UInt) {
        super.init()
        params["namespaceAndName"] = "\(namespace)/\(projectName)"
        params["issueId"] = issueId
    }
    
    public func noteId(noteId: String) -> Self {
        if params["noteId"]? != nil {
            return self
        }
        params["noteId"] = noteId
        return self
    }
}

// MARK: Comment For ProjectSnippets

public class ProjectCommentForSnippetQueryParamBuilder : IssueQueryParamBuilder {
    init(projectId: UInt, snippetId: UInt) {
        super.init()
        params["projectId"] = projectId
        params["snippetId"] = snippetId
    }
    init(projectName: String, namespace: String, snippetId: UInt) {
        super.init()
        params["namespaceAndName"] = "\(namespace)/\(projectName)"
        params["snippetId"] = snippetId
    }
    
    public func noteId(noteId: String) -> Self {
        if params["noteId"]? != nil {
            return self
        }
        params["noteId"] = noteId
        return self
    }
}

// MARK: ProjectDiff

public class ProjectDiffQueryParamBuilder: ProjectCommentForCommitQueryParamBuilder {}

// MARK: ProjectRawfile
// TODO: Handle Project Rawfile
// Raw file content
// Raw blob content
// Get file archive
/*public class ProjectRawfileQueryParamBuilder : GeneralQueryParamBuilder, GitLabParamBuildable {
    
    init(projectId: UInt, sha: String, filePath: String) {
        super.init()
        params["projectId"] = projectId
    }
    init(projectName: String, namespace: String, sha: String, filePath: String) {
        super.init()
        params["namespaceAndName"] = "\(namespace)/\(projectName)"
    }
    
    public func build() -> [String : AnyObject]? {
        return params
    }
}*/