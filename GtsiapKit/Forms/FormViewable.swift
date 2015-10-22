//
//  FormViewable.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 22/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import SnapKit

public protocol FormViewable {
    var resultChanged: ((AnyObject?) -> ())? { get set}
    var required: Bool { get set }
}

public class FormView: UIView, FormViewable {
    public var resultChanged: ((AnyObject?) -> ())?
    public var required: Bool = true
}

public class FormStackView: FormView {

    public var formViews: [FormView] = [FormView]() {
        didSet {
            setupViews()
        }
    }

    private func setupViews() {
        self.subviews.forEach() { $0.removeFromSuperview() }

        var previousView: UIView?
        for view in self.formViews {
            addSubview(view)

            view.snp_makeConstraints() { make in
                if let pv = previousView {
                    make.top.equalTo(pv.snp_bottom)
                } else {
                    make.top.equalTo(self)
                } // end if
            } // end snp_makeConstraints

            previousView = view
        } // end for

        previousView?.snp_remakeConstraints() { make in
            make.bottom.equalTo(self)
        }

    } // end func

}
