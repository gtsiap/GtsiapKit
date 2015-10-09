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

public protocol Themeable {

    var primaryColor: UIColor? { get set }
    var tintColor: UIColor? { get set }

}

extension Themeable {

    public func setup() {
        labelAppearance()
        buttonAppearance()
        searchBarAppearance()
        tabBarAppearance()
        navigationBarAppearance()
        activityIndicatorViewAppearance()
    }

    // MARK: appearance
    public func labelAppearance() {
        UILabel.appearance().font = font()
        UILabel.appearance().lineBreakMode = NSLineBreakMode.ByWordWrapping
        UILabel.appearance().numberOfLines = 0
    }

    public func buttonAppearance() {
        UIButton.appearance().tintColor = self.primaryColor
    }

    public func searchBarAppearance() {
        UISearchBar.appearance().barTintColor = self.primaryColor
        UISearchBar.appearance().tintColor = self.tintColor
    }

    public func tabBarAppearance() {
        UITabBar.appearance().tintColor = self.primaryColor
    }

    public func navigationBarAppearance() {
        UINavigationBar.appearance().barTintColor = self.primaryColor
        UINavigationBar.appearance().tintColor = self.tintColor
    }

    public func activityIndicatorViewAppearance() {
        if let color = self.primaryColor {
            ActivityIndicatorView
                .activityIndicatorViewStyle
                .backgroundColor = color
        }
    }

    // MARK: funcs

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
}

public class Theme: Themeable {

    public var primaryColor: UIColor?
    public var tintColor: UIColor?

}

public class ThemeManager {
    public  static var defaultTheme: Themeable = {
        return Theme()
    }()
}
