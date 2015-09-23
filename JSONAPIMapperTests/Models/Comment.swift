//
//  Comment.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import JSONAPIMapper

final class Comment {
    
    var id: Int?
    var body: String?
    
}

extension Comment: Mappable {
    
    static var resource: String {
        return "comments"
    }
    
    static var relationships: [String : Mappable.Type] {
        return [String : Mappable.Type]()
    }
    
    func map(map: Map) {
        self.body <~ map["body"]
    }
}