//
//  MapToJson.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/1/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

class MapToJSON: Map {
    
    private let object: Mappable
    private var dictionary: [String : AnyObject] = [String : AnyObject]()
    
    init(object: Mappable) {
        self.object = object
    }
    
    func retrieveValue(value: AnyObject?) {
        self.dictionary[self.currentKey] = value
    }
}