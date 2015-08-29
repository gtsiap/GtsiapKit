//
//  Map.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

public class Map {
    
    var includedData: [[String : AnyObject]]?
    
    private let resourceData: [String : AnyObject]
    private var currentKey: String
    
    private lazy var fieldsData: [String : AnyObject] = {
        var fieldsData = [String : AnyObject]()
        
        if let fieldsData = self.resourceData["attributes"] as? [String : AnyObject ] {
            return fieldsData
        }
        
        return [String : AnyObject]()
    }()

    private lazy var relationships: [RelationshipJSONObject]? = {
        if let relationships = self.resourceData["relationships"] as? [String : AnyObject ] {
            return RelationshipJSONObject.fromJSON(relationships)
        }
        
        return nil
    }()
    
    init(resourceData: [String : AnyObject]) {
        self.resourceData = resourceData
        self.currentKey = ""
    }
    
    
    public subscript(key: String) -> Map {
        self.currentKey = key
        return self
    }
    
    func resourceValue<T> () -> T? {
        return self.fieldsData[self.currentKey] as? T
    }
    
    func relationshipValue<T: Mappable> () -> T? {
        let relationshipObject = T()

        guard let relationships = self.relationships else {
            return nil
        }

        let relationship = relationships.filter() {
            $0.jsonField == self.currentKey
        }[0]
        
        // we have found the resource type
        // now we have to find the included data
        
        
        guard let includedData = self.includedData else {
            return nil
        }
        
        for includeDataIt in includedData {
            if
                let dataId = includeDataIt["id"] as? String,
                let id = Int(dataId),
                let resourceType = includeDataIt["type"] as? String
            {
                if id == relationship.id && resourceType == relationship.resourceType {
                    let map = Map(resourceData: includeDataIt)
                    relationshipObject.map(map)
                    
                    return relationshipObject
                }
            }
        }
        
        return nil
    }

    func relationshipValue<T: Mappable> () -> [T]? {
        return nil
    }

}
