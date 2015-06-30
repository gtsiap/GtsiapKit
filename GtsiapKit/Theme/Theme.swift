//
//  Theme.swift
//  Reddit-demo
//
//  Created by Giorgos Tsiapaliokas on 5/25/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public struct ViewShadow {
    public var shadowOpacity = 0.5
    public var shadowRadius = 5
    public var shadowColor = UIColor.blackColor().CGColor
    public var shadowOffset = CGSize(width: -10, height: 10)
}

public protocol ThemeDelegate {

    func instantiateButton(text: String, target: AnyObject, action: Selector) -> UIButton
    func instantiateTextField() -> UITextField
    func instantiateActivityIndicatorView() -> UIActivityIndicatorView
    func instantiateLabel() -> UILabel
    func instantiateFont() -> UIFont
    func instantiateHeadlineFont() -> UIFont
    func instantiateSubheadlineFont() -> UIFont
    func defaultViewShadow() -> ViewShadow
}

public class Theme: ThemeDelegate {
    
    public func instantiateButton(text: String, target: AnyObject, action: Selector) -> UIButton {
        let button = UIButton.buttonWithType(.System) as! UIButton
        button.setTitle(text, forState: .Normal)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        return button
    }
    
    public func instantiateTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .RoundedRect
        textField.font = UIFont.systemFontOfSize(14)
        textField.autocorrectionType = .No
        textField.keyboardType = .Default
        textField.returnKeyType = .Done
        textField.clearButtonMode = .WhileEditing
        return textField
    }
    
    public func instantiateActivityIndicatorView() -> UIActivityIndicatorView {
       let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = UIColor.lightGrayColor()
        return indicator
    }
    
    public func instantiateLabel() -> UILabel {
        let label = UILabel()
        label.font = instantiateFont()
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        return label
    }
    
    public func instantiateFont() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    public func instantiateHeadlineFont() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
    public func instantiateSubheadlineFont() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }
    
    public func defaultViewShadow() -> ViewShadow {
        return ViewShadow()
    }
}
