//
//  TestOperation.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 6/15/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit
import Alamofire

class TestOperation: Operation {
    override func main() {
        request(.GET, "http://reddit.com/r/swift.json")
            .responseJSON() {(request, response, data) in
                print("done")
                self.finish()
        }
        
    }
}
