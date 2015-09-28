//
//  ApiManager.swift
//
//  Created by Giorgos Tsiapaliokas on 7/14/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

let networkLogger = Logger.defaultLogger(["network"])

import Alamofire

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

    // MARK: tasks
    public func task(
        urlRequest: URLRequestConvertible,
        completionHandler: (data: AnyObject?) -> ()
    ) -> ApiTask {
        let task = ApiTask()
        task.request = task.doRequest(urlRequest, completionHandler: completionHandler)
        return task
    }
    
    func goOffline() {
        self.isOffline = true
    }
    
    func goOnline() {
        self.isOffline = false
    }
 }
