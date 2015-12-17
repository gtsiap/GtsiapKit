//
//  UIView+StackView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 24/11/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import TZStackView
import SnapKit

public enum ViewOffset {
    case LeftAndRight
    case ExcludeBottom
    case ExcludeTop
}

extension UIView {

    /**
        It pins the view to the superview
        - parameter edgeInsets: the edge insets, 
                                the default value is (0, 0, 0, 0)
     */
    public func pinToSuperview(edgeInsets: UIEdgeInsets? = nil) {
        guard let superview = superview else {
            fatalError("Did your forget to call addSubview")
        }
        
        snp_makeConstraints() { make in
            let edges = make.edges.equalTo(superview)
            
            guard let edgeInsets = edgeInsets else { return }
            edges.offset(edgeInsets)
        }
        
    }
    
}

extension Array where Element: UIView {
   
    /**
        It creates a stackView from the elements in the array
        - parameter axis: The axis of the stackView the default value
                          is **.Horizontal**
        - parameter distribution: The distribution of the stackView the default value
                                  is **.Fill**
        - parameter alignment: The alignment of the stackView the default value
                               is **.Fill**
     */
    public func toStackView(
        axis: UILayoutConstraintAxis = .Horizontal,
        _ spacing: CGFloat = 0.0,
        distribution: TZStackViewDistribution = .Fill,
        alignment: TZStackViewAlignment = .Fill
    ) -> TZStackView {
        let stackView = TZStackView(arrangedSubviews: self)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
        
        return stackView
    }
    
}