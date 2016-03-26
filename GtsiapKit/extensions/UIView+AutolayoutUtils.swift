// Copyright (c) 2015-2016 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

    func fixedConstraint(attribute: NSLayoutAttribute, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: constant
        )
    }
}
