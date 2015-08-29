//
//  Relationship.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

public struct Relationship {
    
    public let resourceClass: Mappable.Type
    public let jsonField: String
    public let oneToOne: Bool

    var resourceType: String {
        return self.resourceClass.resource
    }

    public init(resourceClass: Mappable.Type, jsonField: String, oneToOne: Bool) {
        self.resourceClass = resourceClass
        self.jsonField = jsonField
        self.oneToOne = oneToOne
    }
    
}
