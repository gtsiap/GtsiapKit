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

let networkLogger = Logger.defaultLogger(["network"])

import Alamofire
import JSONAPIMapper

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
        let task = ApiTask (
            urlRequest: urlRequest,
            completionHandler: completionHandler
        )

        self.didCreateNewTask?(newTask: task)

        return task
    }

    public func task<T>() -> ApiObjectTask<T> {
        let task = ApiObjectTask<T> ()

        self.didCreateNewTask?(newTask: task)

        return task

    }
    
    func task<T: Mappable>() -> JSONApiTask<T> {
        let task = JSONApiTask<T> ()
        
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
