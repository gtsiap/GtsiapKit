//
//  JSONAPIManager.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 09/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import GtsiapKit
import Alamofire
import JSONAPIMapper

public class JSONAPIManager: ApiManager {

    public static let apiManager: JSONAPIManager = JSONAPIManager()

    private override init() {
        super.init()
    }

    // MARK: tasks
    public func fetchResource(
        resourceObject: Mappable.Type,
        completionHandler: (data: AnyObject?) -> ()
    ) -> ApiTask {

        var includeObjects = ""
        for (index, it) in resourceObject.relationships.keys.enumerate() {
            if index != 0 {
                includeObjects += ","
            }

            includeObjects += it
        }

        let requestURL = createRequest(
            resourceObject.resource,
            parameters: [
                "include": includeObjects
            ]
        )

        return task(requestURL, completionHandler: completionHandler)
    }


    private func createRequest(
        path: String,
        parameters: [String : String] = [String : String]()
    ) -> NSMutableURLRequest {

        let URL = NSURL(string: self.baseUrl)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        URLRequest.HTTPMethod = Alamofire.Method.GET.rawValue

        let email = self.userCredentials.email
        let password = self.userCredentials.password

        if !email.isEmpty && !password.isEmpty {
            let loginString = NSString(format: "%@:%@", email, password)
            let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
            let base64LoginString = loginData.base64EncodedStringWithOptions([])

            URLRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }

        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: parameters).0
    }

}
