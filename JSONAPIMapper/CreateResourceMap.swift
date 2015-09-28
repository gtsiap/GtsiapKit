//
//  CreateResourceMap.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/23/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

class CreateResourceMap: RelationshipMap {

    private var dataJSON: [String : AnyObject] {
        var dataJSON: [String : AnyObject] = [
            "type": self.object.dynamicType.resource,
            "attributes": self.fieldsDictionary
        ]

        if !self.relationshipsDictionary.isEmpty {
            dataJSON["relationships"] = self.relationshipsDictionary
        }

        return dataJSON
    }

    var objectJSON: [String : AnyObject] {
        return ["data": self.dataJSON]
    }

}
