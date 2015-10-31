// Copyright (c) 2015 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

public class Json {

    // MARK: properties
    var data: AnyObject?
    public var error: NSError?

    public var string: String? {
        if let d: AnyObject = data, value = d as? String {
            return value
        }
        return nil
    }

    public var int: Int? {
        if let d: AnyObject = data, value = d as? Int {
            return value
        }
        return nil
    }

    public var array: [AnyObject]? {
        if let d: AnyObject = data, value = d as? [AnyObject] {
            return value
        }
        return nil
    }

    public var jsonArray: [Json]? {
        if let d: AnyObject = data, value = d as? [AnyObject] {
            var jsonArray = [Json]()
            for it in value {
                jsonArray.append(Json(it))
            }
            return jsonArray
        }
        return nil
    }

    public var json: Json? {
        if let d: AnyObject = data {
            return Json(d)
        }
        return nil
    }

    // MARK: errors
    private struct Error {
        static let Domain = "NetworkKit.Json"

        static let NotDictionary = -1
        static let NotArray = -2
        static let OutOfBounds = -3
        static let KeyNotFound  = -4

        static let NotDictionaryDescription = "not_dictionary"
        static let NotArrayDescription = "not_Array"
        static let OutOfBoundsDescription = "out_of_bounds"
        static let KeyNotFoundDescription = "key_not_found"
    }

    // MARK: initializers

    public init?(nsData: NSData) {
        var jsonError: NSError? = nil
        let jsonData: AnyObject?
        do {
            jsonData = try NSJSONSerialization.JSONObjectWithData(nsData,
                        options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            jsonError = error
            jsonData = nil
        }

        if jsonError == nil {
            self.data = jsonData
        } else {
            print(jsonError)
            return nil
        }
    }

    public init(_ data: AnyObject?) {
        self.data = data
    }

    public init() {
    }

    // MARK: subscript

    public subscript(key: String) -> Json {
        let j = Json()

        if let e = error {
            j.error = e
            return j
        }

        if data is NSDictionary {
            let d = data as! NSDictionary
            if let keyValue: AnyObject = d[key] {
                j.data = keyValue
            } else {
                j.error = NSError(domain: Error.Domain, code: Error.KeyNotFound, userInfo: [key : Error.KeyNotFoundDescription])
                return j
            }
        } else {
            j.error = NSError(domain: Error.Domain, code: Error.NotDictionary, userInfo: [key : Error.NotDictionaryDescription])
            return j
        }

        return j
    }

    public subscript(index: Int) -> Json {
        let j = Json()

        if let e = error {
            j.error = e
            return j
        }

        if data is NSArray {
            let arr = data as! NSArray

            if index >= arr.count {
                j.error = NSError(domain: Error.Domain, code: Error.OutOfBounds, userInfo: ["error" : Error.OutOfBoundsDescription])
                return j
            }

            j.data = arr[index]
        } else {
            j.error = NSError(domain: Error.Domain, code: Error.NotArray, userInfo: ["error" : Error.NotArrayDescription])
            return j
        }

        return j
    }
}

extension Json : CustomStringConvertible {
    public var description: String {
        return String(data)
    }
}
