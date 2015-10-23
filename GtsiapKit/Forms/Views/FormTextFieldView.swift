//
//  FormTextFieldView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 14/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import SnapKit

public protocol FormTextFieldViewErrorable: class {
    func hasError(string: String) -> (Bool, String)
}

public class FormTextFieldView: FormView {

    var keyboardType: UIKeyboardType = .DecimalPad {
        didSet {
            self.textField.keyboardType = self.keyboardType
        }
    }

    var allowDecimalPoint: Bool = true

    private lazy var textField: UITextField = {
        let textField = UITextField(
            target: self,
            action: "textDidChange"
        )

        textField.borderStyle = .None
        textField.keyboardType = self.keyboardType
        textField.delegate = self

        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

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

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.smallBoldFont()
        label.textColor = UIColor.redColor()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public weak var errorable: FormTextFieldViewErrorable?

    public init(title: String, placeHolder: String, description: String? = nil) {
        super.init(frame: CGRectZero)

        self.formTitle.text = title
        self.textField.placeholder = placeHolder

        self.addSubview(self.textField)
        self.addSubview(self.formTitle)
        self.addSubview(self.errorLabel)

        var leftSideLabel: UILabel = self.formTitle
        var topSideView: UIView?

        if let desc = description {

            self.addSubview(self.formDescription)
            self.formDescription.text = desc
            leftSideLabel = formDescription

            topSideView = self.formTitle

            self.formTitle.font = UIFont.headlineFont()
            self.formTitle.snp_makeConstraints() { make in
                make.top.equalTo(self).offset(10)
                make.centerX.equalTo(self)
            }
        }

        leftSideLabel.snp_makeConstraints() { make in
            if let topView = topSideView {
                make.top.equalTo(topView.snp_bottom).multipliedBy(1.2)
            } else {
                make.top.equalTo(self).offset(10)
            }

            make.centerY.equalTo(self).priorityLow()
            make.left.equalTo(self).offset(10)
        }

        self.errorLabel.snp_makeConstraints() { make in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(self).multipliedBy(0.7)
            make.height.equalTo(self).multipliedBy(0.3)
            make.bottom.equalTo(self)
        }

        self.textField.snp_makeConstraints() { make in
            make.width.equalTo(self).multipliedBy(0.5)
            make.left.equalTo(leftSideLabel.snp_right).multipliedBy(1.5)
            make.right.equalTo(self).multipliedBy(0.9)
            make.centerY.equalTo(leftSideLabel.snp_centerY).priorityLow()
        }

    }

    @objc private func textDidChange() {
        self.resultChanged?(self.textField.text)
    }

}

extension FormTextFieldView: UITextFieldDelegate {
    public func textField(
        textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String
    ) -> Bool {
        // Backspace
        if string.isEmpty {
            return true
        }

        if let text = textField.text
            where string == "." &&
                  !text.containsString(".") &&
                  self.allowDecimalPoint
        {
            return true
        }

        guard let
            errorable = self.errorable
        else { return true }

        let result = errorable.hasError(string)

        if result.0 {
            self.errorLabel.text = result.1
        } else {
            self.errorLabel.text = ""
        }

        return !result.0
    }

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
