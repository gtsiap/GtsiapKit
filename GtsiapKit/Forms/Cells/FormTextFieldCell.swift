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
                self.textField.placeholder = description
            }
        }
    }

    var formDescription: String? {
        didSet {
        }
    }

    private lazy var textField: UITextField = {
        let textField = UITextField(
            target: self,
            action: "textDidChange"
        )

        textField.borderStyle = .None
        textField.keyboardType = .NumberPad
        textField.delegate = self

        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let errorView: UILabel = UILabel()

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

        self.textField.snp_makeConstraints() { make in
            make.width.equalTo(self.contentView).multipliedBy(0.8)
            make.centerY.equalTo(self.contentView)
            make.centerX.equalTo(self.contentView).multipliedBy(0.9)
        }


    }

    @objc private func textDidChange() {
        self.formRow.result = self.textField.text
    }

}

extension FormTextFieldCell: UITextFieldDelegate {
    func textField(
        textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String
    ) -> Bool {
        if string.isEmpty {
            return true
        }

        guard let _ = Int(string) else { return false }
        return true
    }
}
