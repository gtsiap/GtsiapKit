//
//  Map.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

public protocol Map {
    
    subscript(key: String) -> Map { get }

}

class BasicMap: Map {
    private(set) var fieldsDictionary: [String : AnyObject] = [String : AnyObject]()
    private(set) var currentKey: String!

    subscript(key: String) -> Map {
        self.currentKey = key
        return self
    }
    
    func retrieveValue(value: AnyObject?) {
        self.fieldsDictionary[self.currentKey] = value
    }
}

class RelationshipMap: BasicMap {
    let object: Mappable
    private(set) var relationshipsDictionary: [String : AnyObject] = [String : AnyObject]()
    
    init(object: Mappable) {
        self.object = object
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