//
//  UpdateResourceMap.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/23/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

class UpdateResourceMap: BasicMap {

    private let object: Mappable
    
    private var dataJSON: [String : AnyObject] {
        var dataJSON: [String : AnyObject] = [
            "type": self.object.dynamicType.resource,
            "attributes": self.fieldsDictionary
        ]
        
     
        dataJSON["id"] = self.objectId
        
        return dataJSON
    }
    
    private var objectId: String {
        guard let id = self.object.id else {
            fatalError("Missing object id")
        }
        
        return String(id)
    }
    
    var objectJSON: [String : AnyObject] {
        return ["data": self.dataJSON]
    }
    
    init(object: Mappable) {
        self.object = object
        super.init()
    }
    
}
