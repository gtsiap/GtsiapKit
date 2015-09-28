//
//  OperationQueue.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/26/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

public class OperationQueue: NSOperationQueue {

    public var operationsDidFinish: (() -> ())?

    public override init() {
        super.init()

        addObserver(self, forKeyPath: "operationCount", options: NSKeyValueObservingOptions.New, context: nil)
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

        if keyPath != "operationCount" {
            return
        }

        if let queue = object as? NSOperationQueue {
            if queue.operationCount == 0 {
                self.operationsDidFinish?()
            }
        }

    }

}
