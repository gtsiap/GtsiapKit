//
//  UpdateRelationshipMap.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/23/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

class UpdateRelationshipMap: RelationshipMap {

    private let relationship: String
    private let relationshipType: Mappable.Type

    var objectJSON: [String : AnyObject] {

        var data = [[String : AnyObject]]()
        for (key ,value) in self.relationshipsDictionary {

            if key != relationship {
                continue
            }

            guard let
                valueDict = value as? [String : AnyObject]
            else { fatalError() }


            var dataList = [[String : AnyObject]]()

            if let list = valueDict["data"] as? [[String : AnyObject]] {
                dataList = list
            } else if let element = valueDict["data"] as? [String : AnyObject] {
                dataList.append(element)
            } else {
                fatalError()
            }

            for it in dataList {
                guard let dataType = it["type"] as? String else { fatalError() }

                if dataType == relationshipType.resource {
                    data.append(it)
                }
            }

        }

        if data.count == 1 {
            return ["data": data[0]]
        }

        return ["data": data]
    }

    init(
        resourceObject: Mappable,
        relationship: String,
        relationshipType: Mappable.Type
    ) {
        self.relationship = relationship
        self.relationshipType = relationshipType

        super.init(object: resourceObject)
    }

}
