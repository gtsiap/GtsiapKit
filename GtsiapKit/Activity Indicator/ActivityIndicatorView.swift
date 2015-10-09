//
//  ActivityIndicatorView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 7/18/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

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
        if self.superview == nil {
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        self.superview?.bringSubviewToFront(self)
        self.hidden = true

        let centerX = self.superview!.constraint(self, attribute1: .CenterX)
        let centerY = self.superview!.constraint(self, attribute1: .CenterY)

        let width = self.superview!.constraint(self, attribute1: .Width,
            multiplier: 0.4)

        width.priority = UILayoutPriorityDefaultLow

        let height = self.superview!.constraint(self, attribute1: .Height,
            multiplier: 0.2)

        height.priority = UILayoutPriorityDefaultLow

        let aspectRatio = self.superview!.constraint(self, attribute1: .Height, view2: self, attribute2: .Width)
        aspectRatio.priority = UILayoutPriorityDefaultHigh

        self.superview?.addConstraints([centerX, centerY, width, aspectRatio])
    }
}
