//
//  Person.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import JSONAPIMapper

final class Person {

    var id: Int?
    var firstName: String?
    var lastName: String?
    var twitter: String?
    var hobby: Hobby?
}

extension Person: Mappable {

    static var resource: String {
        return "people"
    }

    static var relationships: [String : Mappable.Type] {
        return [
            "hobby2": Hobby.self
        ]
    }

    func map(map: Map) {
        self.firstName <~ map["first-name"]
        self.lastName  <~ map["last-name"]
        self.twitter   <~ map["twitter"]
        self.hobby     <~ map["hobby2"]
    }
}
