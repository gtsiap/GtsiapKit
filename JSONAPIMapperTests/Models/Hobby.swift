//
//  Hobby.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 19/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import JSONAPIMapper

final class Hobby {

    var id: Int?
}

extension Hobby: Mappable {

    static var resource: String {
        return "hobby"
    }

    static var relationships: [String : Mappable.Type] {
        return [String : Mappable.Type]()
    }

    func map(map: Map) {}
}
