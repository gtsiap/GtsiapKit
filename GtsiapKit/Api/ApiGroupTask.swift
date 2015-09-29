//
//  ApiGroupTask.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class ApiGroupTask {

    public var viewController: UIViewController?
    public var toastView: ToastView
    public var showNetworkActivity: Bool
    public var networkIndicator: ActivityIndicatorView

    init() {
        self.networkIndicator = ActivityIndicatorView()
        self.showNetworkActivity = true
        self.toastView = ApiTask.createToast()
    }

    public var tasks: [ApiTask] = [ApiTask]()
}

// MARK: Taskable
extension ApiGroupTask: Taskable {

    public func start() {
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
        }

        stopNetworkActivity()
    }
}

// MARK: ApiPresentable
extension ApiGroupTask: ApiPresentable {

}
