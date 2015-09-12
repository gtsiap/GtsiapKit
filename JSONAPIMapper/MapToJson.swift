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
        let data = [retrieveRelationshipData(relationshipObject)]
        retrieveRelationshipsCommon(relationshipObject, relationshipData: data)
    }
    
    // HACK!!!!!
    // TODO!!!!!
    // In this one we don't need a generic but the compiler SUCKS.
    // If we use Mappable it won't be able to bridge it from objective-c
    // https://www.google.gr/search?q=array+cannot+be+bridged+from+Objective-C&oq=array+cannot+be+bridged+from+Objective-C&aqs=chrome..69i57.449j0j7&sourceid=chrome&es_sm=119&ie=UTF-8
    func retrieveRelationships<T: Mappable>(relationshipObjects: [T]) {
      
        var dataList = [[String : AnyObject]]()

        for relationshipObject in relationshipObjects {
            dataList.append(retrieveRelationshipData(relationshipObject))
        }
        
        retrieveRelationshipsCommon(relationshipObjects[0], relationshipData: dataList)
    }
    
    private func retrieveRelationshipsCommon(
        relationshipObject: Mappable,
        relationshipData: [[String : AnyObject]]
    ) {
        if !self.includeRelationships {
            return
        }
        
        var dataJSON = [String : AnyObject]()
        
        if relationshipData.count == 1 {
            dataJSON["data"] = relationshipData[0]
        } else {
            dataJSON["data"] = relationshipData
        }
        
        for (key, value) in self.object.dynamicType.relationships {
            if value == relationshipObject.dynamicType {
                self.relationshipsDictionary[key] = dataJSON
            }
        } // end for
            
    }
    
    private func retrieveRelationshipData(relationshipObject: Mappable) -> [String : AnyObject] {
        
        guard let id = relationshipObject.id else {
            fatalError("wtf")
        }
            
        let info = [
            "type": relationshipObject.dynamicType.resource,
            "id": String(id)
        ]
        
        return info
    }
    
}