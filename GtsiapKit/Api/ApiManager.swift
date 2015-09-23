//
//  ApiManager.swift
//
//  Created by Giorgos Tsiapaliokas on 7/14/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import Alamofire

let networkLogger = Logger.defaultLogger(["network"])

public struct UserCredentials {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public class ApiManager {
    public static let sharedManager: ApiManager = ApiManager()

    public static var userCredentials: UserCredentials = {
        return UserCredentials(email: "", password: "")
    }()

    public private(set) var isOffline: Bool = false

    private init() {
        Manager.sharedInstance.startRequestsImmediately = false
    }

    func doRequest(urlRequest: URLRequestConvertible,
        completionHandler: (data: AnyObject?) -> Void) -> ApiTask {

        let task = ApiTask()
        task.request = request(urlRequest).response {
            (request, response, data, error) in

             // in future versions check for errors
             networkLogger.debug("request: \(request)")
             networkLogger.debug("response: \(response)")
             networkLogger.debug("error: \(error)")

            var jsonError: NSError?
            let jsonData: AnyObject?
            do {
                jsonData = try NSJSONSerialization.JSONObjectWithData(data!,
                                options: NSJSONReadingOptions.AllowFragments)
            } catch let error as NSError {
                jsonError = error
                jsonData = nil
            } catch {
                fatalError()
            }

            networkLogger.debug("data: \(jsonData)")

            var networkError: NSError?

            // TODO
            if let error = error as? NSError {

                if error.code == -1009 {
                    // no internet connection is available
                    self.isOffline = true

                    if let storedData: AnyObject = self.retrieveRequest(request!) {
                        completionHandler(data: storedData)
                        task.requestDidFinish()

                        return
                    }

                    task.requestDidFinishWithNoNetworkConnection()
                    return
                }

                networkError = error

            } else if jsonError != nil {
                networkError = jsonError
            }

            if error == nil {
                self.isOffline = false
                self.storeRequest(request!, data: jsonData!)
                completionHandler(data: jsonData)
                task.requestDidFinish()
            } else {
                task.requestDidFinishWithError(networkError!)
            }
        }

        return task
    }

    private func storeRequest(urlRequest: NSURLRequest, data: AnyObject) {

        if urlRequest.HTTPMethod != "GET" {
            return
        }

        // save urlRequest.URL and data
    }

    private func retrieveRequest(urlRequest: NSURLRequest) -> AnyObject? {
        return nil
        // return the data if they exist
    }

 }
