//
//  OpearationViewController.swift
//  Example
//
//  Created by Giorgos Tsiapaliokas on 6/12/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit

class OpearationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = NSOperationQueue()

        let operation = TestOperation()
        operation.completionBlock = {
            print("operation finished")
        }

        let op2 = TestOperation()
        op2.completionBlock = {
            print("op2 finished")
        }

        op2.addDependency(operation)

        queue.addOperation(operation)
        queue.addOperation(op2)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

