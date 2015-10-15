//
//  ObjectTransformer.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 15/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class ObjectTransformer<T: ObjectMappable>: Transformer {

    var object: T?
    let handler: (objectMap: Map, object: T) -> ()

    public init(handler: (objectMap: Map, object: T) -> ()) {
        self.handler = handler
    }

    public func fromJSON(map: Map) {
        guard let
            mapFromJSON = map as? MapFromJSON
        else { fatalError() }

        let objectMap = ObjectMap()
        objectMap.data = mapFromJSON.resourceValue()

        if self.object == nil {
            self.object = T()
        }

        self.handler(objectMap: objectMap, object: self.object!)
    }
}
