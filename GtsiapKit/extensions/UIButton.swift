//
//  Button.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 09/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

extension UIButton {

    public convenience init(_ text: String, target: AnyObject, action: Selector) {
        self.init()
        setTitle(text, forState: .Normal)
        addTarget(target, action: action, forControlEvents: .TouchUpInside)

        translatesAutoresizingMaskIntoConstraints = false
    }

}
