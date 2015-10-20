//
//  Int.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 20/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

extension Int {

    public func utcToLocalTime() -> NSDate? {

        guard let
            gmtTimeZone = NSTimeZone(abbreviation: "GMT")
        else { return nil }

        let localTimeZone = NSTimeZone.localTimeZone()

        let date = NSDate(timeIntervalSince1970: NSTimeInterval(self))

        let gmtOffset = gmtTimeZone.secondsFromGMTForDate(date)
        let localOffset = localTimeZone.secondsFromGMTForDate(date)

        let diff = localOffset - gmtOffset

        return NSDate(timeInterval: NSTimeInterval(diff), sinceDate: date)

    }

}
