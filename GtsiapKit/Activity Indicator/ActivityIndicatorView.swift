//
//  ActivityIndicatorView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 7/18/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public struct ActivityIndicatorViewStyle {
    var activityIndicatorStyle: UIActivityIndicatorViewStyle =
        UIActivityIndicatorViewStyle.WhiteLarge

    var backgroundColor: UIColor = UIColor.blackColor()
    var activityIndicatorColor: UIColor = UIColor.whiteColor()
    var textColor: UIColor = UIColor.whiteColor()

    var cornerRadius: CGFloat = 10.0
    var alpha: CGFloat = 0.9
}

public class ActivityIndicatorView: UIView {

    // MARK: public vars

    public var automaticallyPositionInSuperview: Bool = true

    public var activityIndicatorViewStyle: ActivityIndicatorViewStyle =
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
        activityIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.addSubview(activityIndicator)

        let centerX = self.constraint(activityIndicator, attribute1: .CenterX)
        let top = self.constraint(activityIndicator, attribute1: .Top, constant: 10)

        self.addConstraints([centerX, top])

        return activityIndicator
    }()

    private lazy var textLabel: UILabel = {
        let label = ThemeManager.defaultTheme.label()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(label)

        let centerX = self.constraint(label, attribute1: .CenterX)
        let bottom = self.constraint(label, attribute1: .Bottom, constant: -10)

        self.addConstraint(centerX)
        self.addConstraint(bottom)

        return label
    }()

    private func changeTheme() {
        self.backgroundColor = self.activityIndicatorViewStyle.backgroundColor
        self.activityIndicator.activityIndicatorViewStyle =
            self.activityIndicatorViewStyle.activityIndicatorStyle
        self.activityIndicator.color = self.activityIndicatorViewStyle.activityIndicatorColor

        self.textLabel.textColor = self.activityIndicatorViewStyle.textColor
        self.layer.cornerRadius = self.activityIndicatorViewStyle.cornerRadius
        self.alpha = self.activityIndicatorViewStyle.alpha
    }

    private func positionInSuperview() {
        if self.superview == nil {
            return
        }

        setTranslatesAutoresizingMaskIntoConstraints(false)

        self.superview?.bringSubviewToFront(self)
        self.hidden = true

        let centerX = self.superview!.constraint(self, attribute1: .CenterX)
        let centerY = self.superview!.constraint(self, attribute1: .CenterY)

        let width = self.superview!.constraint(self, attribute1: .Width,
            multiplier: 0.4)

        let height = self.superview!.constraint(self, attribute1: .Height,
            multiplier: 0.2)


        self.superview?.addConstraints([centerX, centerY, width, height])
    }
}
