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

import UIKit

public class ApiGroupTask {

    init() {}

    public var tasks: [ApiTask] = [ApiTask]()
}

// MARK: Taskable
extension ApiGroupTask: Taskable {

    public func start() -> ApiGroupTask {
        startNetworkActivity()

        // We just need a queue.
        // Which ISN'T the main queue.
        let queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)

        // also we need a semaphore
        let semaphore = dispatch_semaphore_create(0)

        // Q: What is going on?
        // A: We are about to start a loop
        //    which has a blocker.
        //    dispatch_semaphore_wait is a blocker.
        //    We don't want to freeze the UI.
        // Q: Why async and not sync?
        // A: we don't want to wait for it.
        //    If we wait we will freeze the UI.
        //    We will freeze the UI because this code is very
        //    likely to be executed during the creation
        //    Of the view controllers.
        dispatch_async(queue) {
            for task in self.tasks {
                task.showNetworkActivity = false
                task.start()
                task.taskFinished = {
                    // I am done.
                    // So let the execution flow continue
                    dispatch_semaphore_signal(semaphore)
                }

                // Wait until task is completed
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            }

            dispatch_sync(dispatch_get_main_queue()) {
                self.stopNetworkActivity()
            }
        }

        return self
    }
}

// MARK: ApiPresentable
extension ApiGroupTask: ApiPresentable {

}
