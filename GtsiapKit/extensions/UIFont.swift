//
//  UIFont.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 16/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

extension UIFont {

    public class func normalBoldFont() -> UIFont {
        return ThemeManager.defaultTheme.normalBoldFont()
    }

    public class func smallBoldFont() -> UIFont {
        return ThemeManager.defaultTheme.smallBoldFont()
    }

    public class func headlineFont() -> UIFont {
        return ThemeManager.defaultTheme.headlineFont()
    }

    public class func footnoteFont() -> UIFont {
        return ThemeManager.defaultTheme.footnoteFont()
    }

}
