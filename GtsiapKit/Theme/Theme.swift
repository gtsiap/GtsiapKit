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

public struct ViewShadow {
    public var shadowOpacity: Float = 0.5
    public var shadowRadius: CGFloat = 5.0
    public var shadowColor: CGColor = UIColor.blackColor().CGColor
    public var shadowOffset: CGSize = CGSize(width: -10, height: 10)
}

public protocol Themeable {

    var primaryColor: UIColor? { get set }
    var tintColor: UIColor? { get set }
    var appearanceForTabBar: (() -> ())? { get set }
    var tintColorForControls: UIColor? { get set }
    var selectedTitleTextColor: UIColor? { get set }

}

extension Themeable {

    public func setup() {
        // TODO use UIAppearance.appearanceWhenContainedInInstancesOfClasses
        // when we won't need iOS 8.4
        labelAppearance()
        buttonAppearance()
        searchBarAppearance()
        segmentedAppearance()
        switchAppearance()
        navigationBarAppearance()

        self.appearanceForTabBar?()
    }

    // MARK: appearance
    public func labelAppearance() {
        UILabel.appearance().font = font()
        UILabel.appearance().lineBreakMode = NSLineBreakMode.ByWordWrapping
        UILabel.appearance().numberOfLines = 0
    }

    public func buttonAppearance() {
        if let color = self.tintColorForControls {
            UIButton.appearance().tintColor = color
        }
    }

    public func searchBarAppearance() {
        UISearchBar.appearance().barTintColor = self.primaryColor
        UISearchBar.appearance().tintColor = self.tintColor
    }

    public func navigationBarAppearance() {
        UINavigationBar.appearance().barTintColor = self.primaryColor
        UINavigationBar.appearance().tintColor = self.tintColor

        guard let tintColor = self.tintColor else { return }
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: tintColor
        ]
    }

    public func switchAppearance() {
        UISwitch.appearance().tintColor = self.primaryColor
        UISwitch.appearance().onTintColor = self.tintColorForControls
    }

    public func segmentedAppearance() {
        guard let
            textColor = self.selectedTitleTextColor
        else { return }

        UISegmentedControl.appearance().setTitleTextAttributes([
            NSFontAttributeName: smallBoldFont()
        ], forState: .Normal)

        UISegmentedControl.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: textColor,
            NSFontAttributeName: smallBoldFont()
        ], forState: .Selected)
    }

    // MARK: funcs

    public func font() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }

    public func normalBoldFont() -> UIFont {
        return  UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
    }

    public func smallBoldFont() -> UIFont {
        return  UIFont.boldSystemFontOfSize(UIFont.smallSystemFontSize())
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
    public var appearanceForTabBar: (() -> ())?
    public var tintColorForControls: UIColor?
    public var selectedTitleTextColor: UIColor?

}

public class ThemeManager {
    public  static var defaultTheme: Themeable = {
        return Theme()
    }()
}
