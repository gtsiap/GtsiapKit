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

public class FormIntTextFieldView: FormTextFieldView<Int> {

    public override init(title: String, placeHolder: String, description: String?) {
        super.init(title: title, placeHolder: placeHolder, description: description)
        self.keyboardType = .NumberPad
        self.allowDecimalPoint = false
        self.errorable = self


        self.transformResult = { text -> AnyObject? in
            return Int(text)
        }

        self.valueForMainView = { value in
            guard let
                intValue = value as? Int
            else { return }

            self.textField.text = String(intValue)
        }

    }

}

extension FormIntTextFieldView: FormTextFieldViewErrorable {
    public func hasError(string: String) -> (Bool, String) {

        if let _ = Int(string) {
            return (false, "")
        }

        return (true, "Only Numbers are allowed")
    }

}
