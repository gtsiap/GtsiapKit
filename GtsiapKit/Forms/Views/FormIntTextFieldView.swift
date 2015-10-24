//
//  FormIntTextFieldView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 23/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

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
