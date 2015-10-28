// Copyright (c) 2015 Giorgos Tsiapaliokas
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
import Foundation

public struct ToastViewTheme {
    let cornerRadius: CGFloat = 8.0
    let backgroundColor: UIColor = UIColor.blackColor()
    let textColor: UIColor = UIColor.whiteColor()
}

public class ToastView: UIView {

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(label)

        let widthConstraint = self.constraint(
            label,
            attribute1: .Width,
            view2: self,
            relatedBy: .LessThanOrEqual
        )

        let heightConstraint = self.constraint(label,
            attribute1: .Height,
            view2: self,
            relatedBy: .LessThanOrEqual
        )

        let centerX =  self.constraint(label, attribute1: NSLayoutAttribute.CenterX)
        let centerY =  self.constraint(label, attribute1: NSLayoutAttribute.CenterY)


        self.addConstraints([centerX, centerY, heightConstraint, widthConstraint])

        return label
    }()

    public var automaticallyPositionInSuperview: Bool = true
    public var toastViewTheme: ToastViewTheme = ToastViewTheme()

    public var text: String = ""

    public var timeout: Double = 1.2
    public var toastDidHide: (() -> Void)?

    public func showToast() {
        self.textLabel.text = self.text

        changeToastTheme()

       let timer = NSTimer(
            timeInterval: self.timeout,
            target: self,
            selector: Selector("hideToastView"),
            userInfo: nil,
            repeats: false
        )

        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)

        if self.automaticallyPositionInSuperview {
            positionInSuperview()
        }
    }

    // MARK: Selector

    @objc private func hideToastView() {
        self.hidden = true

        toastDidHide?()
    }

    // MARK: private funcs
    private func changeToastTheme() {
        self.backgroundColor = self.toastViewTheme.backgroundColor
        self.layer.cornerRadius = self.toastViewTheme.cornerRadius
        self.textLabel.textColor = self.toastViewTheme.textColor
    }

    private func positionInSuperview() {
        if self.superview == nil {
            return
        }

        self.superview?.addSubview(self)
        self.superview?.bringSubviewToFront(self)
        translatesAutoresizingMaskIntoConstraints = false

        self.textLabel.preferredMaxLayoutWidth = self.superview!.frame.width

        let size = self.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)

        let height = self.fixedConstraint(.Height, constant: size.height)
        let width = self.fixedConstraint(.Width, constant: size.width)
        let centerX = superview!.constraint(self, attribute1: .CenterX)
        let centerY = superview!.constraint(self, attribute1: .CenterY, multiplier: 1.4)

        superview?.addConstraints([height, width, centerX, centerY])
    }
}
