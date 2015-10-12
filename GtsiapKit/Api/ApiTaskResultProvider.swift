//
//  ApiTaskResultProvider.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 12/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class ApiTaskResultProvider<T> {
    var data: [String : AnyObject] =  [String : AnyObject]()
    
    public typealias TransformerHandler = ((data: [String : AnyObject]) -> ([T]?))?
    
    public var object: [T]? {
        return self.objectTransformer?(data: self.data)
    }

    public var hasDataAvailable:  Bool {
        if self.data.isEmpty {
            return false
        }
        
        return true
    }
    
    public let apiPresentable: ApiPresentable

    public var objectTransformer: TransformerHandler
    
    init(task: ApiObjectTask<T>) {
        self.apiPresentable = task
    }
    
    public func needsUpdate() {
        self.data = [String : AnyObject]()
    }
    
  
}
