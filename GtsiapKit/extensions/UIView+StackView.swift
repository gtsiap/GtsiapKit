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
import SnapKit

public enum ViewOffset {
    case leftAndRight
    case excludeBottom
    case excludeTop
}

extension UIView {

    /**
        It pins the view to the superview
        - parameter edgeInsets: the edge insets, 
                                the default value is (0, 0, 0, 0)
     */
    public func pinToSuperview(_ edgeInsets: UIEdgeInsets? = nil) {
        guard let superview = superview else {
            fatalError("Did your forget to call addSubview")
        }
        
        snp.makeConstraints() { make in
            let edges = make.edges.equalTo(superview)
            
            guard let edgeInsets = edgeInsets else { return }
            edges.inset(edgeInsets)
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
        _ axis: UILayoutConstraintAxis = .horizontal,
        _ spacing: CGFloat = 0.0,
        distribution: UIStackViewDistribution = .fill,
        alignment: UIStackViewAlignment = .fill
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: self)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment
        
        return stackView
    }
    
}
