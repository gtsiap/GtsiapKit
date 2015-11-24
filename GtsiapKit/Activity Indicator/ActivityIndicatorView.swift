// Copyright (c) 2015 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
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

public class ActivityIndicatorViewStyle {
    public var activityIndicatorStyle: UIActivityIndicatorViewStyle =
        UIActivityIndicatorViewStyle.WhiteLarge

    public var backgroundColor: UIColor = UIColor.blackColor()
    public var activityIndicatorColor: UIColor = UIColor.whiteColor()
    public var textColor: UIColor = UIColor.whiteColor()

    public var cornerRadius: CGFloat = 10.0
    public var alpha: CGFloat = 0.9
}

public class ActivityIndicatorView: UIView {

    // MARK: public vars

    public var automaticallyPositionInSuperview: Bool = true

    public static let activityIndicatorViewStyle: ActivityIndicatorViewStyle =
        ActivityIndicatorViewStyle()

    public var text: String = "Loading.." {
        didSet {
            self.textLabel.text = self.text
        }
    }

    // MARK: funcs
    public func startAnimating() {
        changeTheme()
        self.textLabel.text = self.text

        if self.automaticallyPositionInSuperview {
            positionInSuperview()

            layoutIfNeeded()

            self.layer.zPosition = 1.0
            self.hidden = false

            UIView.animateWithDuration(0.5) {
                self.layoutIfNeeded()
            }
        }

        self.activityIndicator.startAnimating()
    }

    public func stopAnimating() {
        self.activityIndicator.stopAnimating()
        self.hidden = true
    }

    // MARK: private vars
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(activityIndicator)

        let centerX = self.constraint(activityIndicator, attribute1: .CenterX)
        let centerY = self.constraint(activityIndicator, attribute1: .CenterY, multiplier: 0.7)

        self.addConstraints([centerX, centerY])

        return activityIndicator
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        let centerX = self.constraint(label, attribute1: .CenterX)
        let bottom = self.constraint(label, attribute1: .Bottom, multiplier: 0.8)

        self.addConstraints([centerX, bottom])
        return label
    }()

    private func changeTheme() {
        self.backgroundColor = ActivityIndicatorView
            .activityIndicatorViewStyle.backgroundColor
        self.activityIndicator.activityIndicatorViewStyle =
            ActivityIndicatorView.activityIndicatorViewStyle.activityIndicatorStyle
        self.activityIndicator.color = ActivityIndicatorView
            .activityIndicatorViewStyle.activityIndicatorColor

        self.textLabel.textColor = ActivityIndicatorView
            .activityIndicatorViewStyle.textColor
        self.layer.cornerRadius = ActivityIndicatorView
            .activityIndicatorViewStyle.cornerRadius
        self.alpha = ActivityIndicatorView
            .activityIndicatorViewStyle.alpha
    }

    private func positionInSuperview() {
        guard let superview = self.superview else {
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        superview.bringSubviewToFront(self)
        self.hidden = true

        let centerX = superview.constraint(self, attribute1: .CenterX)
        let centerY = superview.constraint(self, attribute1: .CenterY, multiplier: 0.7)

        let width = superview.constraint(self, attribute1: .Width,
            multiplier: 0.4)

        width.priority = UILayoutPriorityDefaultLow

        let height = superview.constraint(self, attribute1: .Height,
            multiplier: 0.2)

        height.priority = UILayoutPriorityDefaultLow

        let aspectRatio = superview.constraint(self, attribute1: .Height, view2: self, attribute2: .Width)
        aspectRatio.priority = UILayoutPriorityDefaultHigh

        superview.addConstraints([centerX, centerY, width, aspectRatio])
    }
}
