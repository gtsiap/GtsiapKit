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
    public var shadowColor: CGColor = UIColor.black.cgColor
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
        UILabel.appearance().lineBreakMode = NSLineBreakMode.byWordWrapping
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
        ], for: UIControlState())

        UISegmentedControl.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName: textColor,
            NSFontAttributeName: smallBoldFont()
        ], for: .selected)
    }

    // MARK: funcs

    public func font() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }

    public func normalBoldFont() -> UIFont {
        return  UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }

    public func smallBoldFont() -> UIFont {
        return  UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
    }

    public func headlineFont() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
    }

    public func subheadlineFont() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
    }

    public func footnoteFont() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
    }

    public func defaultViewShadow() -> ViewShadow {
        return ViewShadow()
    }

    public func invisibleViewShadow() -> ViewShadow {
        return ViewShadow(
            shadowOpacity: 0.0,
            shadowRadius: 0,
            shadowColor: UIColor.black.cgColor, // it doesn't matter
            shadowOffset: CGSize(width: 0, height: 0)
        )
    }
}

open class Theme: Themeable {

    open var primaryColor: UIColor?
    open var tintColor: UIColor?
    open var appearanceForTabBar: (() -> ())?
    open var tintColorForControls: UIColor?
    open var selectedTitleTextColor: UIColor?

}

open class ThemeManager {
    open  static var defaultTheme: Themeable = {
        return Theme()
    }()
}
