//
//  ModelUtils.swift
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

var dateTimeTransformer: NSValueTransformer {
    let dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

    return MTLValueTransformer.reversibleTransformerWithForwardBlock({(value: AnyObject!) -> AnyObject! in
            if let val = value as? NSString {
                return dateFormatter.dateFromString(val)
            }
            return nil
        }, reverseBlock: {(value: AnyObject!) -> AnyObject! in
            if let val = value as? NSDate {
                return dateFormatter.stringFromDate(val)
            }
            return nil
    })
}

var dateTransformer: NSValueTransformer {
    let dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return MTLValueTransformer.reversibleTransformerWithForwardBlock({(value: AnyObject!) -> AnyObject! in
            if let val = value as? NSString {
                return dateFormatter.dateFromString(val)
            }
            return nil
        }, reverseBlock: {(value: AnyObject!) -> AnyObject! in
            if let val = value as? NSDate {
                return dateFormatter.stringFromDate(val)
            }
            return nil
    })
}

class ModelUtil<T: GitLabModel> {
    class func transformer() -> NSValueTransformer {
        return NSValueTransformer.mtl_JSONDictionaryTransformerWithModelClass(T.self)
    }
    class func arrayTransformer() -> NSValueTransformer {
        return NSValueTransformer.mtl_JSONArrayTransformerWithModelClass(T.self)
    }
}
