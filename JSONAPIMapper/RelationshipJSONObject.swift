//
//  RelationshipJSONObject.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//


class RelationshipJSONObject {
    let resourceType: String
    let jsonField: String
    let id: Int
    
    private init(resourceType: String, jsonField: String, id: Int) {
        self.resourceType = resourceType
        self.id = id
        self.jsonField = jsonField
    }

    class func fromJSON(JSON: [String : AnyObject]) -> [RelationshipJSONObject]? {
        var objects = [RelationshipJSONObject]()
        
        for it in JSON.keys {
                        
            if
                let jsonObject = JSON[it] as? [String : AnyObject],
                let jsonData = jsonObject["data"] as? [String : AnyObject],
                let type = jsonData["type"] as? String,
                let jsonId = jsonData["id"] as? String,
                let id = Int(jsonId)
            {
                let object = RelationshipJSONObject(
                    resourceType: type,
                    jsonField: it,
                    id: id
                )
                objects.append(object)
            } else if let jsonData = JSON[it] as? [[String : AnyObject]] {
                for dataItem in jsonData {
                    
                    let object = RelationshipJSONObject(
                        resourceType: dataItem["type"] as! String,
                        jsonField: it,
                        id: dataItem["id"] as! Int
                    )
                
                    objects.append(object)
                }
            }
            return objects
        }
        
        return nil
    }
    
}
