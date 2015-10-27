//
//  Int.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 20/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

extension Int {

    public func toLocalTime() -> String {
        let date = NSDate(
            timeIntervalSince1970: NSTimeInterval(self)
        )

        return date.toString
    }

}
