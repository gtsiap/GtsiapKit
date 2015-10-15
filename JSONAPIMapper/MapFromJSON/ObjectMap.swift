//
//  ObjectMap.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 15/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

class ObjectMap: Map {

    var data: [String : AnyObject]?
    private(set) var currentKey: String!

    subscript(key: String) -> Map {
        self.currentKey = key
        return self
    }

    func value<T>() -> T? {
        return self.data?[self.currentKey] as? T
    }

}
