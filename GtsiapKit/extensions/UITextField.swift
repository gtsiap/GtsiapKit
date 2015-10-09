//
//  UITextField.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 09/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

extension UITextField {

    public convenience init(target: AnyObject, action: Selector) {
        self.init()

        borderStyle = .RoundedRect
        font = UIFont.systemFontOfSize(14)
        autocorrectionType = .No
        keyboardType = .Default
        returnKeyType = .Done
        clearButtonMode = .WhileEditing

        addTarget(
            target,
            action: action,
            forControlEvents: .EditingChanged
        )

        translatesAutoresizingMaskIntoConstraints = false
    }

}
