//
//  Mapper.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

public class Mapper<T: Mappable>  {
    
    public func fromJSON(jsonData: [String : AnyObject]) -> [T] {
        
        var objects = [T]()
        
        guard let includedData = jsonData["included"] as? [[String : AnyObject]] else {
            // TODO ERROR
            return objects
        }
        
        if let dataArray = jsonData["data"] as? [[String : AnyObject]] {

            for resourceData in dataArray {
                
                let object = T()
                let map = MapFromJSON(
                    resourceData: resourceData,
                    includedData: includedData,
                    mappableObject: object
                )

                object.map(map)
                objects.append(object)
                
            }
        }
        
        return objects
    }
    
    public func toDictionary(
        resourceObject: Mappable,
        includeRelationships: Bool,
        includeObjectId: Bool = true
    ) throws -> [String : AnyObject] {
        
        let map = MapToJSON(
            object: resourceObject,
            includeRelationships: includeRelationships,
            includeObjectId: includeObjectId
        )
        
        resourceObject.map(map)
        
        return map.objectJSON
    }
    
    public func toJSON(
        resourceObject: Mappable,
        includeRelationships: Bool,
        includeObjectId: Bool = true
    ) throws -> String {
        let objectJSON = try toDictionary(
            resourceObject,
            includeRelationships: includeRelationships,
            includeObjectId: includeObjectId
        )
        
        let data = try NSJSONSerialization.dataWithJSONObject(
            objectJSON,
            options: NSJSONWritingOptions()
        )
        
        guard let stringData = NSString(data: data, encoding: NSUTF8StringEncoding) else {
            fatalError("WTF")
        }
        
        return stringData as String
    }
    
    public func toRelationshipDictionary(
        resourceObject: Mappable,
        relationshipObject: Mappable
    ) throws -> [String : AnyObject] {
        let map = MapToJSON(
            object: resourceObject,
            includeRelationships: true,
            includeObjectId: false
        )
        
        resourceObject.map(map)
        return [String : AnyObject]()
    }
    
    public func toRelationshipJSON(
        resourceObject: Mappable,
        relationshipObject: Mappable
    ) throws -> String {
        return ""
    }
}
