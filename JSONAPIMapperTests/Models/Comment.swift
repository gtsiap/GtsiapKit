//
//  Comment.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import JSONAPIMapper

final class Comment {
    var body: String?
}

extension Comment: Mappable {
    
    static var resource: String {
        return "comments"
    }
    
    static var relationships: [Relationship] {
        return []
    }
    
    func map(map: Map) {
        self.body <~ map["body"]
    }
}