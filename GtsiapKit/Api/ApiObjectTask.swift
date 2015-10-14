//
//  ApiObjectTask.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 12/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import Alamofire

public class ApiObjectTask<T>: ApiTask {
    public typealias ObjectTaskHandler = (result: ApiTaskResultProvider<T>) -> ()
    public private(set) var taskResultProvider: ApiTaskResultProvider<T>!

    private var startHandler: ObjectTaskHandler?

    override init() {
        super.init()
        self.taskResultProvider = ApiTaskResultProvider<T>(task: self)
    }

    public func retrieveObject(completionHandler: ObjectTaskHandler)
        -> ApiObjectTask<T>
    {
        if self.taskResultProvider.hasDataAvailable {
            self.startHandler = completionHandler
            self.request = nil
            return self
        }

        self.startHandler = nil

        self.request = doRequest(self.urlRequest!) { data in
            self.taskResultProvider.data = data
            completionHandler(result: self.taskResultProvider)
        }

        return self
    }

    public override func start() -> ApiObjectTask<T> {
        if let startHandler = self.startHandler {
            startHandler(result: self.taskResultProvider)
            return self
        }

        super.start()

        return self
    }
}
