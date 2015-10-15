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

public extension ApiManager {

    // MARK: tasks

    public func fetchResource<T: Mappable> (
        objectTask: ApiObjectTask<T>,
        includeRelationships: Bool = true
    ) -> ApiObjectTask<T> {

        var includeObjects = ""
        for (index, it) in T.relationships.keys.enumerate() {
            if index != 0 {
                includeObjects += ","
            }

            includeObjects += it
        }

        objectTask.urlRequest = fetchURLRequest(
            T.resource,
            parameters: [
                "include": includeObjects
            ]
        )

        objectTask.taskResultProvider.objectTransformer =
        { (data: [String : AnyObject]) -> ([T]?) in
            do {
                return try Mapper<T>().fromJSON(data)
            } catch let error {
                print("Parsing Error: ")
                print(error)
                return nil
            }
        }

        return objectTask

    }

    public func createResource<T: Mappable> (
        resourceObject: T,
        objectTask: ApiObjectTask<T>
    ) -> ApiObjectTask<T> {

        let body: String

        do {
            body = try Mapper<T>().createResourceJSON(resourceObject)
        } catch let error {
            print("Parsing Error: ")
            print(error)
            fatalError()
        }

        objectTask.urlRequest = createURLRequest(
            T.resource,
            body: body
        )

        objectTask.taskResultProvider.objectTransformer =
        { (data: [String : AnyObject]) -> ([T]?) in
            do {
                return try Mapper<T>().fromJSON(data)
            } catch let error {
                print("Parsing Error: ")
                print(error)
                return nil
            }
        }

        return objectTask
    }

    // MARK: private funcs

    private func fetchURLRequest(
        path: String,
        parameters: [String : String] = [String : String]()
    ) -> NSMutableURLRequest {

        let URL = NSURL(string: self.baseUrl)!
        let urlRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        urlRequest.HTTPMethod = Alamofire.Method.GET.rawValue

        addHeaders(urlRequest)
        addCredentials(urlRequest)

        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(urlRequest, parameters: parameters).0
    }

    private func createURLRequest(
        path: String,
        body: String
    ) -> NSMutableURLRequest {

        let URL = NSURL(string: self.baseUrl)!
        let urlRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        urlRequest.HTTPMethod = Alamofire.Method.POST.rawValue

        addHeaders(urlRequest)
        addCredentials(urlRequest)

        urlRequest.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)

        return urlRequest
    }

    // MARK: common private funcs

    private func addHeaders(urlRequest: NSMutableURLRequest) {
        urlRequest.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")
    }

    private func addCredentials(urlRequest: NSMutableURLRequest) {

        let email = self.userCredentials.email
        let password = self.userCredentials.password

        if !email.isEmpty && !password.isEmpty {
            let loginString = NSString(format: "%@:%@", email, password)
            let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
            let base64LoginString = loginData.base64EncodedStringWithOptions([])

            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }
    }

}
