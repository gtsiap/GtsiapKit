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

    public var maximumTextLength: Int?
    public var minimumTextLength: Int?

    var allowDecimalPoint: Bool = true
    var transformResult: ((text: String) -> AnyObject?)?

    public lazy private(set) var textField: UITextField = {
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

    override init() {
        super.init()
        self.mainView = self.textField
    }

    public init(title: String, placeHolder: String, description: String? = nil) {
        super.init()

        self.textField.placeholder = placeHolder
        self.mainView = self.textField

        configureView(title, description: description)
    }

    public func configureTextFieldView(title: String, placeHolder: String, description: String? = nil) {
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

        if checkTextLength().0 {
            textField.resignFirstResponder()
            return false
        }

        return false
    }

    public override func validate() throws {
        try super.validate()

        let result = checkTextLength()

        if !result.0 {
            throw FormViewableError(message: result.1)
        }

    }

    private func checkTextLength() -> (Bool, String) {
        guard let text = self.textField.text else {
            return (true, "")
        }

        let textCount = text.characters.count

        if let
            minimumLength = self.minimumTextLength
            where textCount < minimumLength
        {
            return (false, "The text is too short for \(self.title)")
        } else if let
            maximumLength = self.maximumTextLength
            where textCount > maximumLength
        {
            return (false, "The text is long short for \(self.title)")
        }

        return (true, "")
    }
}
