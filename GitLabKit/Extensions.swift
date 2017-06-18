//
//  Extensions.swift
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

// MARK: Dictionary

/**
Enable + operator for Dictionary

:param: left  Dictionary
:param: right Dictionary

:returns: Merged dictionary
*/
func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>)
    -> Dictionary<K,V>
{
    var map = Dictionary<K,V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}

// MARK: String

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substring(with: self.index(self.startIndex, offsetBy: r.lowerBound) ..< self.index(self.startIndex, offsetBy: r.upperBound))
    }
}

// MARK: Array

extension Array {
    
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(_ index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
