//
//  Post.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import JSONAPIMapper

final class Info: ObjectMappable {
    var something1: String?
    var something2: Int?
}

final class Post {

    var id: Int?
    var title: String?
    var author: Person?
    var comments: [Comment]?
    var info: Info?
}

extension Post: Mappable {

    static var resource: String {
        return "posts"
    }

    static var relationships: [String : Mappable.Type] {
        return [
            "comments": Comment.self,
            "author": Person.self
        ]
    }

    func map(map: Map) {
        self.title    <~ map["title"]
        self.author   <~ map["author"]
        self.comments <~ map["comments"]

        self.info <~ (map["info"], ObjectTransformer<Info>() { objectMap, object in
            object.something1 <~ objectMap["something1"]
            object.something2 <~ objectMap["something2"]
        })

    }
}
