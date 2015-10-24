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

public class FormTextFieldView<T>: ObjectFormView<T>, UITextFieldDelegate {

    var keyboardType: UIKeyboardType = .DecimalPad {
        didSet {
            self.textField.keyboardType = self.keyboardType
        }
    }

    var allowDecimalPoint: Bool = true
    var transformResult: ((text: String) -> AnyObject?)?

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

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public weak var errorable: FormTextFieldViewErrorable?

    public init(title: String, placeHolder: String, description: String? = nil) {
        super.init()

        self.mainView = self.textField

        self.textField.placeholder = placeHolder
        configureView(title, description: description)
    }

    @objc private func textDidChange() {
        guard let
            text = self.textField.text
        else { return }

        if let transformResult = self.transformResult {
            self.result = transformResult(text: text)
        } else {
            self.result = text
        }

    }

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
            self.viewController?.showAlert(
                "Error",
                message: result.1
            )
        }

        return !result.0
    }

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
