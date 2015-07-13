//
//  Operation.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 6/15/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class Operation : NSOperation {

    override public var concurrent: Bool {
        return true
    }

    override public var asynchronous: Bool {
        return true
    }

    private var _executing: Bool = false {
        willSet(newValue) {
            willChangeValueForKey("isExecuting")
        }
        didSet {
            didChangeValueForKey("isExecuting")
        }
    }

    override public var executing: Bool {
        return self._executing
    }

    private var _finished: Bool = false {
        willSet(newValue) {
            willChangeValueForKey("isFinished")
        }
        didSet {
            didChangeValueForKey("isFinished")
        }
    }

    override public var finished: Bool {
        return self._finished
    }

    override public func start() {
        if (self.cancelled) {
            self._finished = true
            return
        }

        self._executing = true
        self.main()
    }

    public func finish() {
        self._executing = false
        self._finished  = true
    }
}
