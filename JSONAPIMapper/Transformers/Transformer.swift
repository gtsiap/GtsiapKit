//
//  Transformer.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 15/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public protocol Transformer {
    func fromJSON(map: Map)
}
