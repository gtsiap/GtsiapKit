//
//  NSDate+toString.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/8/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

extension NSDate {

    public var toString: String {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = "HH:mm dd/MM/yy"
        return formatter.stringFromDate(self)
    }
}

