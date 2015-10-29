// Copyright (c) 2015 Giorgos Tsiapaliokas
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

    public var maximumValue: Double?
    public var minimumValue: Double?

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

        // this is a writeable form so remove valueForMainView
        // If we don't do it we will rewrite the textField's value
        // and
        // 1. we don't want to do it
        // 2. we don't want to waste cpu

        self.valueForMainView = nil

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

        if checkTextValues().0 {
            textField.resignFirstResponder()
            return false
        }

        return false
    }

    public override func validate() throws {
        try super.validate()

        let resultLength = checkTextLength()
        let resultValue = checkTextValues()

        if !resultLength.0 {
            throw FormViewableError(message: resultLength.1)
        }

        if !resultValue.0 {
            throw FormViewableError(message: resultValue.1)
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

    private func checkTextValues() -> (Bool, String) {
        guard let
            text = self.textField.text,
            textValue = Double(text)
        else {
            return (true, "")
        }

        if let
            minimumValue = self.minimumValue
            where textValue < minimumValue
        {
            return (false, "The value is too small for \(self.title)")
        } else if let
            maximumValue = self.maximumValue
            where textValue > maximumValue
        {
            return (false, "The value is long big for \(self.title)")
        }

        return (true, "")
    }
}
