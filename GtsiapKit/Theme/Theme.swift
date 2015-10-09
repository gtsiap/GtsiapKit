//
//  Theme.swift
//
//  Created by Giorgos Tsiapaliokas on 5/25/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public struct ViewShadow {
    public var shadowOpacity: Float = 0.5
    public var shadowRadius: CGFloat = 5.0
    public var shadowColor: CGColor = UIColor.blackColor().CGColor
    public var shadowOffset: CGSize = CGSize(width: -10, height: 10)
}

public protocol ThemeDelegate {

    func button(text: String, target: AnyObject, action: Selector) -> UIButton
    func textField() -> UITextField
    func activityIndicatorView() -> UIActivityIndicatorView
    func label() -> UILabel
    func font() -> UIFont
    func switcher() -> UISwitch
    func headlineFont() -> UIFont
    func subheadlineFont() -> UIFont
    func footnoteFont() -> UIFont
    func defaultViewShadow() -> ViewShadow
    func invisibleViewShadow() -> ViewShadow

    var primaryColor: UIColor? { get set }
    var tintColor: UIColor? { get set }

}

extension ThemeDelegate {
    public func setup() {

        UINavigationBar.appearance().barTintColor = self.primaryColor
        UINavigationBar.appearance().tintColor = self.tintColor
        
        UITabBar.appearance().tintColor = self.primaryColor
        
        UISearchBar.appearance().barTintColor = self.primaryColor
        UISearchBar.appearance().tintColor = self.tintColor

    }

}

public class Theme: ThemeDelegate {

    public var primaryColor: UIColor?
    public var tintColor: UIColor?

    public func button(text: String, target: AnyObject, action: Selector) -> UIButton {
        let button = UIButton(type: .System)
        button.setTitle(text, forState: .Normal)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        return button
    }

    public func textField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .RoundedRect
        textField.font = UIFont.systemFontOfSize(14)
        textField.autocorrectionType = .No
        textField.keyboardType = .Default
        textField.returnKeyType = .Done
        textField.clearButtonMode = .WhileEditing
        return textField
    }

    public func activityIndicatorView() -> UIActivityIndicatorView {
       let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = UIColor.lightGrayColor()
        return indicator
    }

    public func label() -> UILabel {
        let label = UILabel()
        label.font = font()
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        return label
    }

    public func font() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }

    public func headlineFont() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }

    public func subheadlineFont() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }

    public func footnoteFont() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
    }

    public func defaultViewShadow() -> ViewShadow {
        return ViewShadow()
    }

    public func invisibleViewShadow() -> ViewShadow {
        return ViewShadow(
            shadowOpacity: 0.0,
            shadowRadius: 0,
            shadowColor: UIColor.blackColor().CGColor, // it doesn't matter
            shadowOffset: CGSize(width: 0, height: 0)
        )
    }

    public func switcher() -> UISwitch {
        return UISwitch()
    }
}

public class ThemeManager {
    public  static var defaultTheme: ThemeDelegate = {
        return Theme()
    }()
}
