//
//  UIView+AutolayoutUtils.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 7/12/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public extension UIView {

    func constraint(view1: UIView, attribute1: NSLayoutAttribute,
        view2: UIView, attribute2: NSLayoutAttribute? = nil,
        relatedBy: NSLayoutRelation = NSLayoutRelation.Equal,
        multiplier: CGFloat = 1.0, constant: CGFloat = 0) -> NSLayoutConstraint {

            let attr = attribute2 == nil ? attribute1 : attribute2!
            let constraint = NSLayoutConstraint(
                item: view1,
                attribute: attribute1,
                relatedBy: relatedBy,
                toItem: view2,
                attribute: attr,
                multiplier: multiplier,
                constant: constant
            )

            return constraint
    }

    func constraint(view1: UIView, attribute1: NSLayoutAttribute) -> NSLayoutConstraint {
        return constraint(view1, attribute1: attribute1, view2: self)
    }

    func constraint(view1: UIView, attribute1: NSLayoutAttribute, constant: CGFloat) -> NSLayoutConstraint {
        return constraint(view1, attribute1: attribute1, view2: self, constant: constant)
    }

    func constraint(view1: UIView, attribute1: NSLayoutAttribute, multiplier: CGFloat) -> NSLayoutConstraint {
        return constraint(view1, attribute1: attribute1, view2: self, multiplier: multiplier)
    }

}
