//
//  UIView+Shadow.swift
//
//  Created by Giorgos Tsiapaliokas on 5/25/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

extension UIView {

    public func addShadow(viewShadow: ViewShadow = ThemeManager.defaultTheme.defaultViewShadow()) {
        self.layer.shadowOpacity = viewShadow.shadowOpacity
        self.layer.shadowRadius = viewShadow.shadowRadius
        self.layer.shadowColor = viewShadow.shadowColor
        self.layer.shadowOffset = viewShadow.shadowOffset
    }
    
    public func removeShadow() {
        let viewShadow = ThemeManager.defaultTheme.invisibleViewShadow()
        self.layer.shadowOpacity = viewShadow.shadowOpacity
        self.layer.shadowRadius = viewShadow.shadowRadius
        self.layer.shadowColor = viewShadow.shadowColor
        self.layer.shadowOffset = viewShadow.shadowOffset
    }
}