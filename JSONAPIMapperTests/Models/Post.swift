//
//  Post.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import JSONAPIMapper

final class Post {

    var id: Int?
    var title: String?
    var author: Person?
    var comments: [Comment]?

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
    }
}
