//
//  MapFromJson.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/31/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

class MapFromJSON: BasicMap {
    
    private let includedData: [[String : AnyObject]]
    private let resourceData: [String : AnyObject]
    
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
    
    init(
        resourceData: [String : AnyObject],
        includedData: [[String : AnyObject ]],
        mappableObject: Mappable
    ) {
        self.resourceData = resourceData
        self.includedData = includedData
        
        guard let jsonId = self.resourceData["id"] as? String, id = Int(jsonId) else { fatalError("WTF") }
        mappableObject.id = id
    }
    
    convenience init(resourceData: [String : AnyObject], mappableObject: Mappable) {
        self.init(
            resourceData: resourceData,
            includedData: [[String : AnyObject ]](),
            mappableObject: mappableObject
        )
    }
    
    func resourceValue<T>() -> T? {
        return self.fieldsData[self.currentKey] as? T
    }
    
    func relationshipValue<T: Mappable>() -> T? {
        
        guard let relationships = self.relationships else {
            return nil
        }
        
        let relationship = relationships.filter() {
            $0.jsonField == self.currentKey
        }[0]
        
        return relationshipValueCommon(relationship)
    }
    
    func relationshipValue<T: Mappable> () -> [T]? {
        guard let relationships = self.relationships else {
            return nil
        }
        
        
        let relationshipList = relationships.filter() {
            $0.jsonField == self.currentKey
        }
        
        var relationshipObjects = [T]()
        for relationship in relationshipList {
            let objectOptional: T? = relationshipValueCommon(relationship)
            
            guard let object = objectOptional else { continue }
            
            relationshipObjects.append(object)
        }
        
        guard relationshipObjects.count != 0 else { return nil }
        return relationshipObjects
    }
    
    private func relationshipValueCommon<T: Mappable>(relationship: RelationshipJSONObject) -> T? {

        for includeDataIt in self.includedData {
            if
                let dataId = includeDataIt["id"] as? String,
                let id = Int(dataId),
                let resourceType = includeDataIt["type"] as? String
                where id == relationship.id && resourceType == relationship.resourceType
            {
                let relationshipObject = T()
                let map = MapFromJSON(
                    resourceData: includeDataIt,
                    mappableObject: relationshipObject
                )
                
                relationshipObject.map(map)
                return relationshipObject
            } // end if
        } // end for
        
        return nil
    }

}
