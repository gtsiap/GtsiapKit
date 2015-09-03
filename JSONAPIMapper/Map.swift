//
//  Map.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

public class Map {

    var currentKey: String!
    
    public subscript(key: String) -> Map {
        self.currentKey = key
        return self
    }

}
