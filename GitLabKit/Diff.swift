//
//  Diff.swift
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

public class Diff: GitLabModel, Fetchable {
    public var diff: String?
    public var newPath: String?
    public var oldPath: String?
    public var aMode: String?
    public var bMode: String?
    public var _newFile: NSNumber?
    public var newFile: Bool {
        get { return _newFile? != nil ? _newFile!.boolValue : false }
        set { _newFile = NSNumber(bool: newValue)}
    }
    public var _renamedFile: NSNumber?
    public var renamedFile: Bool {
        get { return _renamedFile? != nil ? _renamedFile!.boolValue : false }
        set { _renamedFile = NSNumber(bool: newValue)}
    }
    public var _deletedFile: NSNumber?
    public var deletedFile: Bool {
        get { return _deletedFile? != nil ? _deletedFile!.boolValue : false }
        set { _deletedFile = NSNumber(bool: newValue)}
    }
    
    public override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var baseKeys: [NSObject : AnyObject] = super.JSONKeyPathsByPropertyKey()
        var newKeys: [NSObject : AnyObject] = [
            "diff"         : "diff",
            "newPath"      : "new_path",
            "oldPath"      : "old_path",
            "aMode"        : "a_mode",
            "bMode"        : "b_mode",
            "_newFile"     : "new_file",
            "_renamedFile" : "renamed_file",
            "_deletedFile" : "deleted_file",
        ]
        return baseKeys + newKeys
    }
}