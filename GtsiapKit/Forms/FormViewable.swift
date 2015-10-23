//
//  FormViewable.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 22/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import SnapKit
import TZStackView

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
        let stackView = TZStackView(arrangedSubviews: self.formViews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical
        addSubview(stackView)

        stackView.snp_makeConstraints() { make in
            make.edges.equalTo(self)
        }
    }
}
