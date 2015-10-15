//
//  Mappable.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

public protocol Mappable: class {
    init()
    func map(map: Map)

    var id: Int? { get set }
    static var resource: String { get }
    static var relationships: [String : Mappable.Type] { get }
}

public protocol ObjectMappable: class {
    init()
}
