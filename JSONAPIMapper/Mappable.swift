//
//  Mappable.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

public protocol Mappable {
    init()
    func map(map: Map)
    
    static var resource: String { get }
    static var relationships: [Relationship] { get }
}
