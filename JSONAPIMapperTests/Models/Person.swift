//
//  Person.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import JSONAPIMapper

final class Person {
    var firstName: String?
    var lastName: String?
    var twitter: String?
}

extension Person: Mappable {
    
    static var resource: String {
        return "people"
    }
    
    static var relationships: [Relationship] {
        return []
    }
    
    func map(map: Map) {
        self.firstName <~ map["first-name"]
        self.lastName  <~ map["last-name"]
        self.twitter   <~ map["twitter"]
    }
}