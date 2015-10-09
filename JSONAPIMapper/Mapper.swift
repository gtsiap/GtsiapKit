//
//  Mapper.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

public class Mapper<T: Mappable>  {
    
    public init(){
        
    }
    
    public func fromJSON(jsonData: [String : AnyObject]) throws -> [T] {

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

    public func createResourceDictionary(resourceObject: T) throws  -> [String : AnyObject] {

        let map = CreateResourceMap(object: resourceObject)
        resourceObject.map(map)

        return map.objectJSON
    }

    public func createResourceJSON(resourceObject: T) throws  -> String {
        return try toJSONString(createResourceDictionary(resourceObject))
    }

    public func updateResourceDictionary(resourceObject: T) throws  -> [String : AnyObject] {

        let map = UpdateResourceMap(object: resourceObject)
        resourceObject.map(map)

        return map.objectJSON
    }

    public func updateResourceJSON(resourceObject: T) throws  -> String {
        return try toJSONString(updateResourceDictionary(resourceObject))
    }

    public func updateRelationshipDictionary(
        resourceObject: T,
        relationship: String,
        relationshipType: Mappable.Type
    ) throws  -> [String : AnyObject] {

        let map = UpdateRelationshipMap(
            resourceObject: resourceObject,
            relationship: relationship,
            relationshipType: relationshipType
        )

        resourceObject.map(map)

        return map.objectJSON
    }

    public func updateRelationshipJSON(
        resourceObject: T,
        relationship: String,
        relationshipType: Mappable.Type
    ) throws  -> String {
        return try toJSONString(updateRelationshipDictionary(
            resourceObject,
            relationship: relationship,
            relationshipType: relationshipType
        ))
    }

    // MARK: private funcs
    private func toJSONString(dictionary: [String : AnyObject]) throws -> String {
        let data = try NSJSONSerialization.dataWithJSONObject(
            dictionary,
            options: NSJSONWritingOptions()
        )

        guard let stringData = NSString(data: data, encoding: NSUTF8StringEncoding) else {
            fatalError()
        }

        return stringData as String
    }

}
