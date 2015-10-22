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

    private lazy var textField: UITextField = {
        let textField = UITextField(
            target: self,
            action: "textDidChange"
        )

        textField.borderStyle = .None
        textField.keyboardType = .DecimalPad
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

    public init(description: String, placeHolder: String) {
        super.init(frame: CGRectZero)

        self.formDescription.text = description
        self.textField.placeholder = placeHolder

        self.addSubview(self.textField)
        self.addSubview(self.formDescription)
        self.addSubview(self.errorLabel)

        self.formDescription.snp_makeConstraints() { make in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
        }

        self.errorLabel.snp_makeConstraints() { make in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(self).multipliedBy(0.7)
            make.height.equalTo(self).multipliedBy(0.3)
            make.top.equalTo(self.formDescription.snp_bottom)
            make.bottom.equalTo(self)
        }

        self.textField.snp_makeConstraints() { make in
            make.width.equalTo(self).multipliedBy(0.7)
            make.left.equalTo(self.formDescription.snp_right).multipliedBy(1.5)
            make.centerY.equalTo(self.formDescription.snp_centerY)
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
            where string == "." && !text.containsString(".")
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
}
