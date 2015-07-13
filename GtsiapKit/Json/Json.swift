//
//  JsonReader.swift
//  NetworkKit
//
//  Created by Giorgos Tsiapaliokas on 5/13/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

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
        let jsonData: AnyObject? = NSJSONSerialization.JSONObjectWithData(nsData,
            options: NSJSONReadingOptions.AllowFragments,
            error: &jsonError)

        if jsonError == nil {
            self.data = jsonData
        } else {
            println(jsonError)
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

extension Json : Printable {
    public var description: String {
        return toString(data)
    }
}
