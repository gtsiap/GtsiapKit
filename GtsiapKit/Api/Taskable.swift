//
//  Taskable.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/23/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public protocol Taskable {
    typealias ClassSelf = Self
    func start() -> ClassSelf
}
