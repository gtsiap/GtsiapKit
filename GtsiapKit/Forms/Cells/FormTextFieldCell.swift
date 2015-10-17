//
//  FormTextFieldCell.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 14/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import SnapKit

class FormTextFieldCell: UITableViewCell {

    var formRow: FormRow! {
        didSet {
            if case .Double(let description) = self.formRow.type {
                self.formDescription.text = description
            }

            if self.formRow.required {
                self.textField.placeholder = "Required"
            }
        }
    }

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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
    }
    private func commonInit() {

        self.contentView.addSubview(self.textField)
        self.contentView.addSubview(self.formDescription)
        self.contentView.addSubview(self.errorLabel)

        self.formDescription.snp_makeConstraints() { make in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(10)
        }

        self.errorLabel.snp_makeConstraints() { make in
            make.left.equalTo(self.contentView).offset(10)
            make.width.equalTo(self.contentView).multipliedBy(0.7)
            make.height.equalTo(self.contentView).multipliedBy(0.3)
            make.top.equalTo(self.formDescription.snp_bottom)
            make.bottom.equalTo(self.contentView)
        }

        self.textField.snp_makeConstraints() { make in
            make.width.equalTo(self.contentView).multipliedBy(0.7)
            make.left.equalTo(self.formDescription.snp_right).multipliedBy(1.5)
            make.centerY.equalTo(self.formDescription.snp_centerY)
        }

    }

    @objc private func textDidChange() {
        self.formRow.result = self.textField.text
    }

    private func hasErrors(string: String) -> Bool {

        self.errorLabel.text = ""

        switch self.formRow.type {
        case .Double:
            if let _ = Double(string) {
                return false
            }

            self.errorLabel.text = "Only Numbers are allowed"

        default:
            break
        }

        return true
    }

}

extension FormTextFieldCell: UITextFieldDelegate {
    func textField(
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

        return !hasErrors(string)
    }
}
