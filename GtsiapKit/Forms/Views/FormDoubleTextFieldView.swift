//
//  FormDoubleTextFieldView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 22/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class FormDoubleTextFieldView: FormTextFieldView<Double> {

    public override init(title: String, placeHolder: String, description: String?) {
        super.init(title: title, placeHolder: placeHolder, description: description)
        self.errorable = self

        self.transformResult = { text -> AnyObject? in
            return Double(text)
        }

        self.valueForMainView = { value in
            guard let
                doubleValue = value as? Double
            else { return }

            self.textField.text = String(doubleValue)
        }

    }

}

extension FormDoubleTextFieldView: FormTextFieldViewErrorable {
    public func hasError(string: String) -> (Bool, String) {

        if let _ = Double(string) {
            return (false, "")
        }

        return (true, "Only Numbers are allowed")
    }

}
