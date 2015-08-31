//
//  Map.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

public class Map {
    
    var includedData: [[String : AnyObject]]?
    
    var currentKey: String
    
    lazy var fieldsData: [String : AnyObject] = {
        var fieldsData = [String : AnyObject]()
        
        if let fieldsData = self.resourceData["attributes"] as? [String : AnyObject ] {
            return fieldsData
        }
        
        return [String : AnyObject]()
    }()

    lazy var relationships: [RelationshipJSONObject]? = {
        if let relationships = self.resourceData["relationships"] as? [String : AnyObject ] {
            return RelationshipJSONObject.fromJSON(relationships)
        }
        
        return nil
    }()
    
    private let resourceData: [String : AnyObject]
    
    init(resourceData: [String : AnyObject], mappableObject: Mappable) {
        self.resourceData = resourceData
        self.currentKey = ""
        
        guard let jsonId = self.resourceData["id"] as? String, id = Int(jsonId) else { fatalError("WTF") }
        mappableObject.id = id
    }
    
    
    public subscript(key: String) -> Map {
        self.currentKey = key
        return self
    }
    
}
