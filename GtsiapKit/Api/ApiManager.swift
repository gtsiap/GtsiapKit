//
//  ApiManager.swift
//
//  Created by Giorgos Tsiapaliokas on 7/14/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

let networkLogger = Logger.defaultLogger(["network"])

import Alamofire

public class ApiManager {
    public static var sharedManager: ApiManager = ApiManager()

    public var userCredentials: UserCredentials = {
        return UserCredentials(email: "", password: "")
    }()

    public var didCreateNewTask: ((newTask: ApiTask) -> ())? = nil
    public private(set) var isOffline: Bool = false

    public var baseUrl: String!

    public init() {
        Manager.sharedInstance.startRequestsImmediately = false
    }

    // MARK: tasks
    public func task(
        urlRequest: URLRequestConvertible,
        completionHandler: (data: [String : AnyObject]) -> ()
    ) -> ApiTask {
        let task = ApiTask(
            urlRequest: urlRequest,
            completionHandler: completionHandler
        )

        self.didCreateNewTask?(newTask: task)

        return task
    }

    public func groupTask(tasks: [ApiTask]) -> ApiGroupTask {
        let task = ApiGroupTask()
        task.tasks = tasks
        return task
    }

    func goOffline() {
        self.isOffline = true
    }

    func goOnline() {
        self.isOffline = false
    }
 }
