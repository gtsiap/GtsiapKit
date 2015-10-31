
// Copyright (c) 2015 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
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

public class ObjectFormView<T>: FormView {
    public var resultObject: T? {
        return self.result as? T
    }

    init() {
        super.init(frame: CGRectZero)
    }
}

public class FormView: UIView, FormViewable  {

    public var result: AnyObject? {
        didSet {
            self.resultDidChange?(self.result)
            self.valueForMainView?(self.result)
        }
    }

    // This closure will provide programmtically
    // a value for the mainView.
    public var valueForMainView: ((AnyObject?) -> ())?

    public var resultDidChange: ((AnyObject?) -> ())?
    public weak var viewController: UIViewController?

    public var required: Bool = true

    public var mainView: UIView!
    public var title: String {
        return self.formTitle.text ?? ""
    }

    public var placeMainViewInRightSide: Bool = false
    public var fillHeightForMainView: Bool = false
    public var fillWidthForMainView: Bool = false
    public var customHeightForForm: CGFloat?

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

    public func validate() throws {
        if let _ = self.result {
            return
        }

        throw FormViewableError(message: "")
    }

    public func configureView(title: String, description: String? = nil) {
        self.formTitle.text = title

        self.addSubview(self.mainView)
        self.addSubview(self.formTitle)

        var leftSideLabel: UILabel = self.formTitle
        var topSideView: UIView?

        if self.fillWidthForMainView {

            self.formTitle.snp_makeConstraints() { make in
                make.top.equalTo(self)
                make.centerX.equalTo(self)
            }

            self.mainView.snp_makeConstraints() { make in
                if self.fillHeightForMainView {
                    make.top.equalTo(self.formTitle.snp_bottom).multipliedBy(1.2)
                }

                make.left.right.equalTo(self)

                make.bottom.equalTo(self)
            }

            return
        }

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

            if !self.placeMainViewInRightSide {
                make.width.equalTo(self).multipliedBy(0.6)
                make.left.equalTo(leftSideLabel.snp_right).multipliedBy(1.5)
            }

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
