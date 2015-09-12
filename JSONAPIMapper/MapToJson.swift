//
//  MapToJson.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/1/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

class MapToJSON: Map {
    
    private let includeObjectId: Bool
    private let includeRelationships: Bool
    private let object: Mappable
    private var fieldsDictionary: [String : AnyObject] = [String : AnyObject]()
    private var relationshipsDictionary: [String : AnyObject] = [String : AnyObject]()
    
    private var dataJSON: [String : AnyObject] {
        var dataJSON: [String : AnyObject] = [
            "type": self.object.dynamicType.resource,
            "attributes": self.fieldsDictionary
        ]
        
        if self.includeObjectId {
            dataJSON["id"] = self.objectId
        }
        
        if !self.relationshipsDictionary.isEmpty || self.includeRelationships {
            dataJSON["relationships"] = self.relationshipsDictionary
        }
        
        return dataJSON
    }
    
    private var objectId: String {
        guard let id = self.object.id where self.includeObjectId else {
            fatalError("Missing object id")
        }
        
        return String(id)
    }
    
    var objectJSON: [String : AnyObject] {
        return ["data": self.dataJSON]
    }
    
    init(object: Mappable, includeRelationships: Bool, includeObjectId: Bool) {
        self.object = object
        self.includeObjectId = includeObjectId
        self.includeRelationships = includeRelationships
    }
    
    func retrieveValue(value: AnyObject?) {
        self.fieldsDictionary[self.currentKey] = value
    }
    
    func retrieveRelationship(relationshipObject: Mappable) {
         if !self.includeRelationships {
            return
        }
        
        guard let id = relationshipObject.id else {
            fatalError("wtf")
        }
        
        let info = [
            "type": relationshipObject.dynamicType.resource,
            "id": String(id)
        ]
        
        let dataJSON = ["data": info]
        
        for (key, value) in self.object.dynamicType.relationships {
            if value == relationshipObject.dynamicType {
                self.relationshipsDictionary[key] = dataJSON
            }
        } // end for
        
    }
    
}