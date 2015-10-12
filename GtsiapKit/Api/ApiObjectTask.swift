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
    public private(set) var taskResultProvider: ApiTaskResultProvider<T>!

    override init() {
        super.init()
        self.taskResultProvider = ApiTaskResultProvider<T>(task: self)
    }

    public func retrieveObject(
        completionHandler: (result: ApiTaskResultProvider<T>) -> ())
        -> ApiObjectTask<T>
    {
        if self.taskResultProvider.hasDataAvailable {
            completionHandler(result: self.taskResultProvider)
            return self
        }

        self.request = doRequest(self.urlRequest!) { data in
            self.taskResultProvider.data = data
            completionHandler(result: self.taskResultProvider)
        }

        return self
    }
}
