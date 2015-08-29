//
//  Operators.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

infix operator <~ {}

public func <~ <T>(inout left: T?, right: Map) {
    left = right.resourceValue()
}

public func <~ <T: Mappable>(inout left: T?, right: Map) {
    left = right.relationshipValue()
}

public func <~ <T: Mappable>(inout left: [T]?, right: Map) {
    left = right.relationshipValue()
}