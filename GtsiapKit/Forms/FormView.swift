//
//  FormView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 23/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import SnapKit

public class FormView: UIView, FormViewable  {

    public var result: AnyObject? {
        didSet {
            self.resultDidChange?(self.result)
        }
    }

    public var resultDidChange: ((AnyObject?) -> ())?
    public weak var viewController: UIViewController?

    public var required: Bool = true

    public var mainView: UIView!
    public var title: String? {
        return self.formTitle.text
    }

    var fillHeightForMainView: Bool = false

    private lazy var formDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.normalBoldFont()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var formTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.normalBoldFont()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    public func configureView(title: String, description: String? = nil) {
        self.formTitle.text = title

        self.addSubview(self.mainView)
        self.addSubview(self.formTitle)

        var leftSideLabel: UILabel = self.formTitle
        var topSideView: UIView?

        if let desc = description {

            self.addSubview(self.formDescription)
            self.formDescription.text = desc
            leftSideLabel = formDescription

            topSideView = self.formTitle

            self.formTitle.font = UIFont.headlineFont()
            self.formTitle.snp_makeConstraints() { make in
                make.top.equalTo(self)
                make.centerX.equalTo(self)
            }
        }

        leftSideLabel.snp_makeConstraints() { make in
            if let topView = topSideView {
                make.top.equalTo(topView.snp_bottom).multipliedBy(1.2)
            } else {
                make.top.equalTo(self)
            }

            make.centerY.equalTo(self).priorityLow()
            make.left.equalTo(self)
        }

        self.mainView.snp_makeConstraints() { make in
            make.width.equalTo(self).multipliedBy(0.6)
            make.left.equalTo(leftSideLabel.snp_right).multipliedBy(1.5)
            make.right.equalTo(self)

            if self.fillHeightForMainView {
                if let topView = topSideView {
                    make.top.equalTo(topView.snp_bottom).multipliedBy(1.2)
                } else {
                    make.top.equalTo(self)
                }

                make.bottom.equalTo(self)
            } else {
                // we set priorityLow in order to allow the FormView to
                // work correctly in other views like StackView
                make.centerY
                    .equalTo(leftSideLabel.snp_centerY)
                    .priorityLow()
            }

        }

    }

}
