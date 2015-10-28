// Copyright (c) 2015 Giorgos Tsiapaliokas
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
            self.request = nil
        }

        return self
    }

    public override func start() -> ApiObjectTask<T> {

        if let startHandler = self.startHandler {
            // When ApiObjectTasks is used with ApiGroupTask
            // these funcs will be called from another thread
            // which isn't the main thread
            dispatch_async(dispatch_get_main_queue()) {
                self.requestDidFinish()
                startHandler(result: self.taskResultProvider)
            }

            return self
        }

        super.start()

        return self
    }
}
