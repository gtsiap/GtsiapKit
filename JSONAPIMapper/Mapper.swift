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
                let map = Map(resourceData: resourceData)
                map.includedData = includedData
                object.map(map)

                objects.append(object)
                
            }
        }
        
        return objects
    }
    
}
